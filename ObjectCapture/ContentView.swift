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
            HStack(alignment: .top, content: {
                VStack {
                    Text("Files")
                        .font(.system(size: 14, design: .rounded))
                }
                .frame(width: geometry.size.width * 1 / 5)
                .frame(height: geometry.size.height)
                .background(Color("leftPanelBackground"))
                ZStack {
                    
                }
                .frame(width: geometry.size.width * 4 / 5)
                .frame(height: geometry.size.height)
                .background(Color(.white))
            })
        }
    }
}

#Preview {
    ContentView()
}

