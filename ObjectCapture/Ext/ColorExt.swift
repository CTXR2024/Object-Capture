//
//  ColorExt.swift
///  An extension for the `Color` struct to initialize colors using hexadecimal strings.
/// Supports the following formats:
/// - RGB (12-bit) with a leading `#`, e.g., "#ABC"
/// - RGB (24-bit) with or without a leading `#`, e.g., "AABBCC" or "#AABBCC"
/// - ARGB (32-bit) with or without a leading `#`, e.g., "FFAABBCC" or "#FFAABBCC"
///
/// Hexadecimal strings that do not match these formats will result in black color.
/// The extension assumes sRGB color space for the conversion.
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
