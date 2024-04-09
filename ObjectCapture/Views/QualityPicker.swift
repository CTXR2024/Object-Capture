//
//  QualityPicker.swift
//  ObjectCapture
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI

struct QualityPicker: View {
    
    @State var selectedQuality: Quality = .raw
    
    var body: some View {
        Picker(selection: $selectedQuality, label: Text("")) {
            ForEach(Quality.allCases) { quality in
                Text(quality.rawValue)
                    .padding(5)
            }
        }
        .pickerStyle(.radioGroup)
    }
}

#Preview {
    QualityPicker()
}
