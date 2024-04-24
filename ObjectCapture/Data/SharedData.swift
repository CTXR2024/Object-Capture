//
//  SharedData.swift
//  ObjectCapture
//
//  Created by peytonwu on 2024/4/11.
//

import Foundation
import Metal
import Combine

final class SharedData: ObservableObject {
    @Published var modelViewerModelURL: URL?
    @Published var modelProgressViewState: ModelProgressView.PresentationState = .hidden
    @Published var modelProcessingProgress: CGFloat = 0.0
    @Published var showInFinderURL: URL?
}

