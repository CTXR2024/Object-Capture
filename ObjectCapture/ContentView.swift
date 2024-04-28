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
//    @State private var showingCancelAlert = false
    @State private var shouldResetCamera = false
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Sidebar(photogrammetrySession: $photogrammetrySession)
                Spacer()
                ZStack{
                    Group{
                        if let modelURL = sharedData.modelViewerModelURL{
                            ModelViewer(modelURL: modelURL,shouldResetCamera: $shouldResetCamera).frame(maxWidth:.infinity, maxHeight: .infinity)
                        } else {
                            Label("Preview or export a model to see it here!", systemImage: "arkit").font(.title2).padding(150)
                        }
                        
                    }.frame(maxHeight: .infinity)
                    ModelProgressView(cancelAction: {
                        showingCancel()
                    })
                    .padding()
                }
                
                
            }.frame(width: geo.size.width, height: geo.size.height)
        }.onDisappear {
            photogrammetrySession?.cancel()
            if let modelViewerModelURL = sharedData.modelViewerModelURL {
                try? ModelFileManager().removeTempModel(modelURL: modelViewerModelURL)
                print("remove temp model \(modelViewerModelURL)")
            }
        }.onExitCommand {
            if photogrammetrySession?.isProcessing ?? false {
                showingCancel()
            }
        }.onAppear{
            if !PhotogrammetrySession.isSupported {
                AlertTools.show("Sorry About That", message: "Sorry your current macOS does not support Object Capture.", primaryTitle: "Exit", secondaryTitle: "View Details", onSecondary:  {
                    let urlStr = "https://developer.apple.com/documentation/RealityKit/creating-3d-objects-from-photographs#Check-for-availability"
                    let url = URL(string: urlStr)!
                    NSWorkspace.shared.open(url)
                })
            }
        }.customAlert()
    }
    
    func showingCancel() {
        AlertTools.show("StopCreatingModelAlertTitle", message: "StopCreatingModelAlertBody", primaryTitle: "Cancel", secondaryTitle: "Stop", onSecondary: {
            photogrammetrySession?.cancel()
        })
    }
    
}

#Preview {
    ContentView()
}

