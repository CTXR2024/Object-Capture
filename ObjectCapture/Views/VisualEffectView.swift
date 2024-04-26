//
//  VisualEffectView.swift
//  ObjectCapture
//
//  Created by peytonwu on 2024/4/12.
//

import Foundation
import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let vfxView = NSVisualEffectView()

        vfxView.material = material
        vfxView.blendingMode = blendingMode
        vfxView.state = NSVisualEffectView.State.active

        return vfxView
    }

    func updateNSView(_ vfxView: NSVisualEffectView, context: Context) {
        vfxView.material = material
        vfxView.blendingMode = blendingMode
    }
}
