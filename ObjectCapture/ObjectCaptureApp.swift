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
            ContentView().environmentObject(sharedData)
        }
    }
}
