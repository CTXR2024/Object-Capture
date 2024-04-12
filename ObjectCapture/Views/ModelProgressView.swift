//
//  ModelProgressView.swift
//  ObjectCapture
//
//  Created by peytonwu on 2024/4/11.
//

import Foundation
import SwiftUI

struct ModelProgressView: View {
    @EnvironmentObject private var sharedData: SharedData
    var cancelAction: () -> Void
    
    enum PresentationState {
        case hidden
        case initializing
        case bar
        case copying
        case finished }
    
    var body: some View {
        Group {
            switch sharedData.modelProgressViewState{
            case .hidden:
                EmptyView()
            case .initializing:
                HStack {
                    ProgressView().scaleEffect(0.6)
                    Text("Initializing").font(.title3)
                    Spacer()
                }
            case .bar:
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("CreatingModel \(Int(sharedData.modelProcessingProgress * 100))").bold().font(.body)
                        ProgressView(value: sharedData.modelProcessingProgress, total: 1)
                    }
                    Button(action: cancelAction) {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .help(String("StopCreating"))
                    .buttonStyle(BorderlessButtonStyle())
                }
            case .copying:
                HStack {
                    ProgressView()
                        .scaleEffect(0.6)
                    Text("SavingModel", comment: "Text: Shown in progress bar while saving a finished model")
                        .font(.title3)
                    Spacer()
                }
            case.finished:
                HStack {
                    Label {
                        Text("ExportComplete \(sharedData.showInFinderURL?.lastPathComponent ?? "")",
                             comment: "Text: Shown in progress bar after a model has been successfully exported")
                    }icon: {
                        Image(systemName: "checkmark.circle")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.green)
                            .imageScale(.large)
                            .font(.title2)
                    }
                    .font(.title3)
                    Spacer()
                    Button(String(localized: "ShowInFinder", comment: "Button: Shows the exported model in Finder")) {
                        NSWorkspace.shared.selectFile(sharedData.showInFinderURL?.path, inFileViewerRootedAtPath: "")
                    }
                    Button {
                        withAnimation {
                            sharedData.modelProgressViewState = .hidden
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .help(
                        String(
                            localized: "Dismiss",
                            comment: "Button: Hides the progress bar before it automatically hides after successful export"))
                    .buttonStyle(BorderlessButtonStyle())
                }
                
            }
        }
        .zIndex(1)
        .transition(.move(edge: .bottom))
        .frame(maxWidth: .infinity, maxHeight: 25)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .shadow(radius: 15)
                .foregroundStyle(.regularMaterial)
        )
        .onChange(of: sharedData.modelProgressViewState) { oldValue,newValue in
            if newValue == .finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    withAnimation {
                        sharedData.modelProgressViewState = .hidden
                    }
                }
            }
        }
    }
}
