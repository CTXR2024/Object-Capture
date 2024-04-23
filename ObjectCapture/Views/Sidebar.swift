//
//  LeftPannel.swift
//  ObjectCapture
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct Sidebar: View {
    
    private static let defualtWidth: CGFloat = 220.0
    
    @State private var width: CGFloat = defualtWidth //  defautl width is 220pt
    @State private var selectedImageFolder : URL?
    @State private var selectedOutputFolder : URL?
    
    var body: some View {
        VStack {
            filesSection
            Spacer()
            finalProcessingQualitySection
        }
        .frame(width: self.width)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(Color(hex: "#4B4B4B"))
    }
}

private extension Sidebar {
    var filesSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Files")
                    .font(.headline)
                    .frame(alignment: .leading)
                FolderSelectionView(selectedImageFolder: self.$selectedImageFolder,selectedOutputFolder: self.$selectedOutputFolder,inputBlock: {}, outputBlock: {
                    self.selectedOutputFolder = openSaveFolderPanel()
                    if let url = selectedOutputFolder {
                        print("The url is \(url)")
                    }
                })
                Divider()
                    .foregroundColor(.white)
            }
            Button(action: {
                //todo generate the quality of preview model
                AlertTools.show("sadsad", message: "hhhh", primaryTitle: "Close")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    AlertTools.show("222222", message: "2222222")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        AlertTools.show("3333", message: "33333", primaryTitle: "Primary", secondaryTitle: "Secondary", onPrimary: {}, onSecondary: {})
                    })
                    
                })
            }) {
                Text("Preview")
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private extension Sidebar {
    var finalProcessingQualitySection : some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Final Processing Quality")
            QualityPicker()
            Button(action: {}) {
                Text("Create Model")
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
            }
            .font(.caption2)
            .frame(maxWidth: .infinity)
        }
    }
}

extension Sidebar {
    private func openSaveFolderPanel() -> URL? {
        let panel = NSSavePanel()
        panel.title = "Choose a Folder to Save Your Model"
        panel.canCreateDirectories = true
        panel.allowedContentTypes = [.usdz]
        return panel.runModal() == .OK ? panel.url : nil
    }
}

#Preview {
    Sidebar()
}
