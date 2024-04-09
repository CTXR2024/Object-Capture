//
//  ContentView.swift
//  ObjectCapture
//
//  Created by jayjiang on 22/03/2024.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Sidebar()
                QuickLookPreview()
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    ContentView()
}

