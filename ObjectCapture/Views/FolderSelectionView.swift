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
            FolderButton(isSelected: selectedImageFolder != nil, label: selectedImageFolder?.path ?? "Image Folder", action: inputBlock)
                .frame(width: 100)
                .background(RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(nsColor: .underPageBackgroundColor)))
            
            FolderButton(isSelected: selectedOutputFolder != nil, label: selectedOutputFolder?.path ?? "Output Folder", action: outputBlock)
                .frame(width: 100)
                .background(RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(nsColor: .underPageBackgroundColor)))
            
        }
    }
}

#Preview {
    FolderSelectionView(selectedImageFolder: .constant(nil), selectedOutputFolder: .constant(nil), inputBlock: {}, outputBlock: {})
        .frame(width: 500)
        .background(.white)
}
