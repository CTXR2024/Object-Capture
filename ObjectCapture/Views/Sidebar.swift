//
//  LeftPannel.swift
//  ObjectCapture
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI

struct Sidebar: View {
    
    private static let DEFAULT_WIDTH: CGFloat = 220.0
    
    @State private var width: CGFloat = DEFAULT_WIDTH //  defautl width is 220pt
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Files")
                        .font(.headline)
                        .frame(alignment: .leading)
                    FolderSelectionView(inputBlock: {}, outputBlock: {})
                    Divider()
                        .foregroundColor(.white)
                }
                Button(action: {}) {
                    Text("Preview")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Text("Final Processing Quality")
                QualityPicker()
                Button(action: {
                    //todo generate the model
                }) {
                    Text("Create Model")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(width: self.width)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(Color(hex: "#4B4B4B"))
    }
}

#Preview {
    Sidebar()
}
