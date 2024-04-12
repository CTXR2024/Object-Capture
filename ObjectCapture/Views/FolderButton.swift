//
//  FolderButton.swift
//  ObjectCapture
//
//  Created by jayjiang on 25/03/2024.
//

import SwiftUI

struct FolderButton: View {
    
    var isSelected: Bool = false
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: isSelected ? "folder" : "square.and.arrow.down")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                Text(label)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(Color(nsColor: isSelected ? .selectedControlTextColor : .disabledControlTextColor))
            }
            .frame(maxWidth:.infinity)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(nsColor: .windowBackgroundColor)))
        }
        .buttonStyle(.plain)
        
    }
}

#Preview {
    FolderButton(isSelected: false, label: "Image Folder", action: {})
}
