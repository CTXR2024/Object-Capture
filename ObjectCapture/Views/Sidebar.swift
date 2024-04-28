//
//  LeftPannel.swift
//  ObjectCapture
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import RealityKit

struct Sidebar: View {
    
    typealias Detail = PhotogrammetrySession.Request.Detail
    
    @State private var processingErrorOccurred = false
    @State private var selectedImageFolder : URL?
    @State private var selectedOutputFolder : URL?
    @State private var selectedQuality: Quality = .reduced
    @EnvironmentObject var sharedData: SharedData
    @Binding var photogrammetrySession: PhotogrammetrySession?
    @State var psConfig = PhotogrammetrySession.Configuration()
    
    var body: some View {
        VStack {
            filesSection
            Spacer()
            finalProcessingQualitySection
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 10)
        .background(Color(hex: "#4B4B4B"))
    }
    
    private func showAlert(title: String, message: String, primaryAction: @escaping ()->Void) {
        AlertTools.show(title, message: message, primaryTitle: "Select Folder", secondaryTitle: "Close", onPrimary: {
            processingErrorOccurred = true
            primaryAction()
        })
    }
}

private extension Sidebar {
    var filesSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Files")
                    .font(.headline)
                    .frame(alignment: .leading)
                FolderSelectionView(selectedImageFolder: self.$selectedImageFolder,selectedOutputFolder: self.$selectedOutputFolder,inputBlock: selectSourceFolder, outputBlock: selectSaveModelFile)
                Divider()
                    .foregroundColor(.white)
            }
            Button(action: createPreview) {
                Text("Preview")
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    var finalProcessingQualitySection: some View {
        return VStack(alignment: .leading, spacing: 20) {
            Text("Final Processing Quality")
            QualityPicker(selectedQuality: $selectedQuality)
            Button(action: {
                createModel()
            }) {
                Text("Create Model")
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}


extension Sidebar {
    
    private func openInputImagesFolder() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        return openPanel.runModal() == .OK ? openPanel.url : nil
    }
    
    private func openOutputModelFolderPanel() -> URL? {
        let panel = NSSavePanel()
        let text = "Choose a Folder to Save Your Model"
        panel.title = text
        panel.canCreateDirectories = true
        panel.allowsOtherFileTypes = false
        panel.allowedContentTypes = [.usdz]
        return panel.runModal() == .OK ? panel.url : nil
    }
    
    private func selectSourceFolder(){
        self.selectedImageFolder = openInputImagesFolder()
        
        if let url = selectedImageFolder {
            print("The input url is \(url)")
        }
    }
    
    private func selectSaveModelFile(){
        self.selectedOutputFolder = openOutputModelFolderPanel()
        if let url = selectedOutputFolder {
            print("The url is \(url)")
        }
    }
}

private extension Sidebar {
    
    private func createPreview() {
        guard let inputURL = selectedImageFolder else {
            showAlert(title: "No Image Selected", message: "Previewing and Creating a model requires selecting the folder where the image material is located", primaryAction: selectSourceFolder)
            return
        }
        startPhotogrammetrySession(detail: Detail.preview, inputURL: inputURL)
    }
    
    private func createModel() {
        guard let inputURL = selectedImageFolder else {
            showAlert(title: "No Image Selected", message: "Previewing and Creating a model requires selecting the folder where the image material is located", primaryAction: selectSourceFolder)
            return
        }
        guard let outputURL = selectedOutputFolder else {
            showAlert(title: "No Output Folder Selected", message: "Please specify the final output folder of the model", primaryAction: selectSaveModelFile)
            return
        }
        startPhotogrammetrySession(detail: selectedQuality.detail, inputURL: inputURL, permanentURL: outputURL)
    }
    
    private func startPhotogrammetrySession(detail: Detail, inputURL: URL, permanentURL: URL? = nil) {
        do {
            photogrammetrySession = try PhotogrammetrySession(input: inputURL, configuration: psConfig)
            configureSessionOutputHanling(permanentURL: permanentURL, detail: detail)
        } catch {
            print("Could not create photogrammetry session, aborting...")
            processingErrorOccurred = true
            AlertTools.show("System Error", message: " \(error.localizedDescription)")
        }
    }
    
    private func configureSessionOutputHanling(permanentURL: URL?, detail: Detail) {
        let temporarySaveURL = ModelFileManager().generateTempModelURL(appropriateFor: permanentURL)
        let request = PhotogrammetrySession.Request.modelFile(url: temporarySaveURL, detail: detail)
        withAnimation {
            sharedData.modelProgressViewState = .initializing
        }
        processSession(request: request, temporarySaveURL: temporarySaveURL, permanentURL: permanentURL)
    }
    
    private func processSession(request: PhotogrammetrySession.Request, temporarySaveURL: URL, permanentURL: URL?) {
        guard let session = photogrammetrySession else {return}
        Task(priority: .userInitiated) {
            do {
                for try await output in session.outputs {
                    switch output {
                    case .processingComplete:
                        // RealityKit has processed all requests.
                        handleCreationCompletion(temporaryLocation: temporarySaveURL, permenantSaveURL: permanentURL)
                    case .requestError(_, _):
                        // Request encountered an error.
                        processingErrorOccurred = true
                    case .requestComplete(_, _):
                        // RealityKit has finished processing a request.
                        print("Completed request!")
                    case .requestProgress(_, let fractionComplete):
                        // Periodic progress update. Update UI here.
                        DispatchQueue.main.async {
                            sharedData.modelProgressViewState = .bar
                            sharedData.modelProcessingProgress = fractionComplete
                        }
                    case .inputComplete:
                        // Ingestion of images is complete and processing begins.
                        print("Successfully initiallized images, beginning processing...")
                    case .invalidSample(let id, let reason):
                        // RealityKit deemed a sample invalid and didn't use it.
                        print("Sample with the id \(id) is invalid. Reason: \(reason)")
                    case .skippedSample(let id):
                        // RealityKit was unable to use a provided sample.
                        print("Skipped a sample image with id: \(id)")
                    case .automaticDownsampling:
                        // RealityKit downsampled the input images because of
                        // resource constraints.
                        print("Enabled auto downsampling because of limited system resources!")
                    case .processingCancelled:
                        // Processing was canceled.
                        DispatchQueue.main.async {
                            withAnimation {
                                sharedData.modelProgressViewState = .hidden
                            }
                        }
                    @unknown default:
                        // Unrecognized output.
                        print("Extra output")
                    }
                }
            } catch {
                processingErrorOccurred = true
                AlertTools.show("System Error", message: " \(error.localizedDescription)")
            }
        }
        do {
            withAnimation {
                sharedData.modelProgressViewState = .initializing
            }
            try session.process(requests: [request])
        } catch {
            processingErrorOccurred = true
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
            AlertTools.show("System Error", message: " \(error.localizedDescription)")
        }
    }
   
    @MainActor
    private func handleCreationCompletion(temporaryLocation: URL, permenantSaveURL: URL? = nil) {
        if processingErrorOccurred {
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
            return
        }
        
        let modelFileManager = ModelFileManager()
        
        let oldModelURL = sharedData.modelViewerModelURL
        
        withAnimation {
            sharedData.modelViewerModelURL = temporaryLocation
        }
        
        if let oldURL = oldModelURL {
            try? modelFileManager.removeTempModel(modelURL: oldURL)
        }
        
        if let saveURL = permenantSaveURL {
            sharedData.modelProgressViewState = .copying
            do {
                try modelFileManager.copyTempModel(tempModelURL: temporaryLocation, permanentURL: saveURL)
                sharedData.showInFinderURL = saveURL
                sharedData.modelProgressViewState = .finished
            } catch {
                print("Cannot save model to destination URL")
                
            }
        } else {
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
        }
    }
    
    private func openSystemPreferences(){
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func getApplicationName() -> String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        } else if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return appName
        }
        return "App"
    }
}

#Preview {
    Sidebar(photogrammetrySession:.constant(nil))
}
