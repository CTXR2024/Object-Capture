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
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Sidebar(photogrammetrySession: $photogrammetrySession).environmentObject(sharedData)
                Spacer()
                ZStack{
                    Group{
                        if let modelURL = sharedData.modelViewerModelURL{
                            SceneKitView(modelURL: modelURL)
                        } else {
                            Label("Preview or export a model to see it here!", systemImage: "arkit").font(.title2).padding(150)
                        }
                        
                    }.frame(maxHeight: .infinity)
                    ModelProgressView(cancelAction: {
                        showingCancelAlert.toggle()
                    })
                    .environmentObject(sharedData)
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
                showingCancelAlert.toggle()
            }
        }.alert(isPresented: $showingCancelAlert) {
            Alert(
                title:
                    Text("StopCreatingModelAlertTitle"),
                message:
                    Text("StopCreatingModelAlertBody"),
                primaryButton:
                        .cancel(),
                secondaryButton:
                        .destructive(Text("Stop"), action: { photogrammetrySession?.cancel() })
            )
        }
    }
}

#Preview {
    ContentView()
}

