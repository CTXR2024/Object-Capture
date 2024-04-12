//
//  ContentView.swift
//  ObjectCapture
//
//  Created by jayjiang on 22/03/2024.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var alertData = AlertTools.shared
    @State private var showAlert = false
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Sidebar()
                QuickLookPreview()
            }.frame(width: geo.size.width, height: geo.size.height)
                .alert(isPresented: $alertData.isPresented) {
                    Alert(
                        title: Text(alertData.title),
                        message: (alertData.message != nil) ? Text(alertData.message ?? "") : nil
                    )
                    
                }
        }
    }
}

#Preview {
    ContentView()
}

