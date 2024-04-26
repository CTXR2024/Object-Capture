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
    @State private var showingCancelAlert = false
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
                    showingCancelAlert.toggle()
                })
                .padding()
            }
        }
        .onDisappear {
            photogrammetrySession?.cancel()
            if let modelViewerModelURL = sharedData.modelViewerModelURL {
                try? ModelFileManager().removeTempModel(modelURL: modelViewerModelURL)
                print("remove temp model \(modelViewerModelURL)")
            }
        }
        .onExitCommand {
            if photogrammetrySession?.isProcessing ?? false {
                showingCancelAlert.toggle()
            }
        }
        .alert(isPresented: $showingCancelAlert) {
            Alert(
                title:
                    Text("Terminate Now"),
                message:
                    Text("Are you sure you want to terminate the current model generation progress?"),
                primaryButton:
                        .default(
                            Text("Terminate"),
                            action: { photogrammetrySession?.cancel() }
                        ),
                secondaryButton:
                        .cancel()
            )
        }
    }
}

#Preview {
    ContentView()
}

