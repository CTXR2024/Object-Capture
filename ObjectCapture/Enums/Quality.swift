//
//  Quality.swift
///  It present the all quality types for model creation
///  Please refer to PhotogrammetrySession.Request.Detail
//
//  Created by jayjiang on 08/04/2024.
//

import RealityKit

enum Quality: String, CaseIterable, Identifiable {
    
    case preview = "preview"
    case reduced = "Reduced"
    case medium = "Medium"
    case full = "Full"
    case raw = "Raw"
    
    typealias Detail = PhotogrammetrySession.Request.Detail
    
    var id: Self {self}
    
    var detail: Detail {
        switch self {
        case .preview:
            return .preview
        case .reduced:
            return .reduced
        case .medium:
            return .medium
        case .full:
            return .full
        case .raw:
            return .raw
        }
    }
}
