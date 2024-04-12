//
//  LeftPannel.swift
//  ObjectCapture
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import RealityKit
import UserNotifications

struct Sidebar: View {
   
    private static let defualtWidth: CGFloat = 220.0
    @State private var processingErrorOccurred = false
    @State private var width: CGFloat = defualtWidth //  defautl width is 220pt
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
        .frame(width: self.width)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(Color(hex: "#4B4B4B"))
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
                if let destinationURL = selectedOutputFolder {
                    createModel(permanent: destinationURL)
                }else{
                    selectSaveModelFile()
                }
            }) {
                Text("Create Model")
            }
            .font(.caption2)
            .frame(maxWidth: .infinity)
        }
    }
}


extension Sidebar {
    private func openInputImagesFolder() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        if openPanel.runModal() == .OK {
            return openPanel.url
        }
        return nil
    }
    
    private func openOutputModelFolderPanel() -> URL? {
        let panel = NSSavePanel()
        let text = "Choose a Folder to Save Your Model"
        if #available(macOS 11.0, *){
            panel.message = text
        }else{
            panel.title = text
        }
               
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
        selectedQuality = .preview
        createModel()
    }
    
    private func createModel(permanent: URL? = nil) {
        
        processingErrorOccurred = false

        guard let inputURL = selectedImageFolder else {
            processingErrorOccurred = true
            selectSourceFolder()
            return
        }

        do {
            photogrammetrySession = try PhotogrammetrySession(input: inputURL, configuration: psConfig)
        } catch {
            print("Could not create photogrammetry session, aborting...")
            processingErrorOccurred = true
            return
        }

        let temporarySaveURL = ModelFileManager().generateTempModelURL(appropriateFor: permanent)
        let request = PhotogrammetrySession.Request.modelFile(url: temporarySaveURL, detail: permanent == nil ? .preview : selectedQuality.detail)

        Task(priority: .userInitiated) {
            do {
                for try await output in photogrammetrySession!.outputs {
                    switch output {
                    case .inputComplete:
                        print("Successfully initiallized images, beginning processing...")
                    case .requestError:
                        print("Request error!")
                        processingErrorOccurred = true
                        
                    case .requestComplete:
                        print("Completed request!")
                    case .requestProgress(_, fractionComplete: let fractionComplete):
                        print("Current request is \(Int(fractionComplete*100))% complete")
                        sharedData.modelProgressViewState = .bar
                        sharedData.modelProcessingProgress = fractionComplete
                    case .processingComplete:
                        print("Done processing!")
                        handleCreationCompletion(temporaryLocation: temporarySaveURL, permenantSaveURL: permanent)
                    case .processingCancelled:
                        print("Processing is cancelled")
                        withAnimation {
                            sharedData.modelProgressViewState = .hidden
                        }
                    case .invalidSample(id: let id, reason: let reason):
                        print("Sample with the id \(id) is invalid. Reason: \(reason)")
                    case .skippedSample(id: let id):
                        print("Skipped a sample image with id: \(id)")
                    case .automaticDownsampling:
                        print("Enabled auto downsampling because of limited system resources!")
                    @unknown default:
                        print("Received unknown session output: \(output)")
                    }
                }
            } catch {
                print("Unexpected fatal session error. Aborting... ERROR=\(error)")
                processingErrorOccurred = true
            }
        }

        do {
            withAnimation {
                sharedData.modelProgressViewState = .initializing
            }

            try photogrammetrySession!.process(requests: [request])
        } catch {
            print("Cannot process requests. ERROR=\(error)")
            processingErrorOccurred = true
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
        }
        
    }
    private func handleCreationCompletion(temporaryLocation: URL, permenantSaveURL: URL? = nil) {
        if processingErrorOccurred {
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
            sendCreationConclusionNotification(success: false, exportedModelFilename: permenantSaveURL?.lastPathComponent)
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
        sendCreationConclusionNotification(success: true, exportedModelFilename: permenantSaveURL?.lastPathComponent)
    }
    private func sendCreationConclusionNotification(success: Bool, exportedModelFilename: String?) {
        let content = UNMutableNotificationContent()

        if let filename = exportedModelFilename {
            if success {
                content.title = String(
                    localized: "ModelExportSuccessNotificationTitle",
                    comment: "Notification title for model export success")
                content.subtitle = String(format:
                                            String(
                                                localized: "ModelExportSuccessNotificationBody %@",
                                                comment: "Notification body for model export success"),
                                          filename)
            } else {
                content.title = String(
                    localized: "ModelExportFailureNotificationTitle",
                    comment: "Notification title for model export failure")
                content.subtitle = String(format:
                                            String(
                                                localized: "ModelExportFailureNotificationBody %@",
                                                comment: "Notification body for model export failure"),
                                          filename)
            }
        } else if let inputFolderName = selectedImageFolder?.lastPathComponent {
            if success {
                content.title = String(
                    localized: "PreviewCreationSuccessNotificationTitle",
                    comment: "Notification title for preview creation success")
                content.subtitle = String(
                    format: String(
                        localized: "PreviewCreationSuccessNotificationBody %@",
                        comment: "Notification body for preview creation success"),
                    inputFolderName)
            } else {
                content.title = String(
                    localized: "PreviewCreationFailureNotificationTitle",
                    comment: "Notification title for preview creation failure")
                content.subtitle = String(format:
                                            String(
                                                localized: "PreviewCreationFailureNotificationBody %@",
                                                comment: "Notification body for preview creation failure"),
                                          inputFolderName)
            }
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    Sidebar(photogrammetrySession:.constant(nil))
}
