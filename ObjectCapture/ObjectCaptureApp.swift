//
//  ObjectCaptureApp.swift
//  ObjectCapture
//
//  Created by jayjiang on 22/03/2024.
//

import SwiftUI

@main
struct ObjectCaptureApp: App {
    
    @State private var showSheet = false
    
    @StateObject private var sharedData = SharedData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1280, maxWidth: .infinity, minHeight: 720, maxHeight: .infinity)
                .environmentObject(sharedData)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
