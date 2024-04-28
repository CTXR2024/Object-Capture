//
//  ContentView.swift
//  ObjectCapture
//
//  Created by jayjiang on 22/03/2024.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @EnvironmentObject private var sharedData: SharedData
    @State private var photogrammetrySession: PhotogrammetrySession?
    @State private var shouldResetCamera = false
    @State private var splitViewController: NSSplitViewController?
    
    var body: some View {
        NavigationSplitView {
            Sidebar(photogrammetrySession: $photogrammetrySession)
                .frame(minWidth: 220, maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    VisualEffectView(material: .windowBackground, blendingMode: .behindWindow)
                        .edgesIgnoringSafeArea(.all)
                )
        } detail: {
            ZStack(alignment: .bottom){
                VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
                Group(){
                    if let modelURL = sharedData.modelViewerModelURL{
                        ModelViewer(modelURL: modelURL,shouldResetCamera: $shouldResetCamera).frame(maxWidth:.infinity, maxHeight: .infinity)
                    } else {
                        Label("Preview or export a model to see it here!", systemImage: "arkit")
                            .font(.title2)
                            .padding(150)
                            .frame(maxWidth:.infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    
                }.frame(maxHeight: .infinity)
                ModelProgressView(cancelAction: {
                    showingCancel()
                })
                .padding()
            }
        }
        .onAppear{
            if !PhotogrammetrySession.isSupported {
                AlertTools.show(
                    "Feature Unavailable",
                    message: "Object Capture is not supported on your current macOS version. For optimal experience, please consider updating your system or visit the following link for more details.",
                    primaryTitle: "Exit",
                    secondaryTitle: "Learn More",
                    onSecondary:  {
                        if let url = URL(string: "https://developer.apple.com/documentation/RealityKit/creating-3d-objects-from-photographs#Check-for-availability") {
                            NSWorkspace.shared.open(url)
                        } else {
                            print("Failed to create URL for details")
                        }
                    }
                )
            }
        }
        .customAlert()
        .onDisappear {
            photogrammetrySession?.cancel()
            if let modelViewerModelURL = sharedData.modelViewerModelURL {
                try? ModelFileManager().removeTempModel(modelURL: modelViewerModelURL)
                print("remove temp model \(modelViewerModelURL)")
            }
        }
        .onExitCommand {
            if photogrammetrySession?.isProcessing ?? false {
                showingCancel()
            }
        }
    }
    
    func showingCancel() {
        AlertTools.show(
            "Terminate Now",
            message: "Are you sure you want to terminate the current model generation progress?",
            primaryTitle: "Terminate",
            secondaryTitle: "Cancel",
            onPrimary: {
                photogrammetrySession?.cancel()
            }
        )
    }
    
}

#Preview {
    ContentView()
}

