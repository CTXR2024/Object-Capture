//
//  FolderSelectionView.swift
//  ObjectCapture
//
//  Created by jayjiang on 25/03/2024.
//

import SwiftUI

struct FolderSelectionView : View {
    
    @Binding var selectedImageFolder : URL?
    @Binding var selectedOutputFolder : URL?
    var inputBlock: () -> Void
    var outputBlock: () -> Void
    
    var body: some View {
        
        HStack(spacing: 10.0) {
            Button(action: inputBlock, label: {
                FolderButton(isSelected: selectedImageFolder != nil, label: selectedImageFolder?.path ?? "Image Folder")
                    .frame(width: 100)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(nsColor: .underPageBackgroundColor)))
            }).buttonStyle(PlainButtonStyle())
            
            Button(action: outputBlock, label: {
                FolderButton(isSelected: selectedOutputFolder != nil, label: selectedOutputFolder?.path ?? "Output Folder")
                    .frame(width: 100)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(nsColor: .underPageBackgroundColor)))
            }).buttonStyle(PlainButtonStyle())
            
            
        }
    }
}

#Preview {
    FolderSelectionView(selectedImageFolder: .constant(nil), selectedOutputFolder: .constant(nil), inputBlock: {}, outputBlock: {})
        .frame(width: 500)
        .background(.white)
}
