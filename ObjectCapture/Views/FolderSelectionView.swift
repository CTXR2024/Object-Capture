//
//  FolderSelectionView.swift
//  ObjectCapture
//
//  Created by jayjiang on 25/03/2024.
//

import SwiftUI

struct FolderSelectionView : View {
    
    @State private var selectedImageFolder : URL?
    @State private var selectedOutputFolder : URL?
    var inputBlock: () -> Void
    var outputBlock: () -> Void
    
    var body: some View {
        
        HStack(spacing: 10.0) {
            FolderButton(isSelected: selectedImageFolder != nil, label: "Image Folder", action: {
                inputBlock()
            })
            .frame(minWidth: 100)
            .background(RoundedRectangle(cornerRadius: 10.0)
                .fill(Color(nsColor: .underPageBackgroundColor)))
            
            FolderButton(isSelected: selectedImageFolder != nil, label: "Output Folder", action: {
                outputBlock()
            })
            .frame(minWidth: 100)
            
            .background(RoundedRectangle(cornerRadius: 10.0)
                .fill(Color(nsColor: .underPageBackgroundColor)))
        }
    }
}

#Preview {
    FolderSelectionView(inputBlock: {}, outputBlock: {})
        .frame(width: 500)
        .background(.white)
}