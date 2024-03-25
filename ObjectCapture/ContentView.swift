//
//  ContentView.swift
//  ObjectCapture
//
//  Created by jayjiang on 22/03/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            
            let leftPanelWidth = geometry.size.width * 1 / 4
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Files")
                        .font(.headline)
                        .frame(alignment: .leading)
                    FolderSelectionView()
                    Divider()
                        .foregroundColor(.white)
                    Spacer().frame(height: 2)
                    Button(action: {}) {
                        Text("Preview")
                            .font(.caption2)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: leftPanelWidth, height: geometry.size.height, alignment:.topLeading)
                .padding(.top, 20.0)
                .padding(.horizontal, 10.0)
                .background(Color("leftPanelBackground"))
                ZStack {
                    
                }
                .frame(width: leftPanelWidth * 3)
                .frame(height: geometry.size.height)
                .background(Color(.white))
            }
        }
    }
}




#Preview {
    ContentView()
}

