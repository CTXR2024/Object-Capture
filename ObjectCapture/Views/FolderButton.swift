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
    
    init(isSelected: Bool, label: String, action: @escaping () -> Void) {
        self.isSelected = isSelected
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(spacing: 2) {
                Image(systemName: isSelected ? "folder" : "square.and.arrow.down")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                Text(isSelected ? "Folder Selected" : label)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(isSelected ? .white : .gray)
            }
        })
        .padding(10)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FolderButton(isSelected: false, label: "ImageFolder", action: {})
}
