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
    
    
    var body: some View {
        
        HStack(spacing: 10.0) {
            FolderButton(isSelected: selectedImageFolder != nil, label: "Image Folder", action: {})
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(nsColor: .underPageBackgroundColor)))
            FolderButton(isSelected: selectedImageFolder != nil, label: "Output Folder", action: {}).frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(nsColor: .underPageBackgroundColor)))
        }
    }
}

#Preview {
    FolderSelectionView()
        .frame(width: 500)
        .background(.white)
}
