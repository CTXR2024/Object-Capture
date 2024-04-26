//
//  QualityPicker.swift
//  ObjectCapture
//
//  Created by jayjiang on 08/04/2024.
//

import SwiftUI

struct QualityPicker: View {
    
    @Binding var selectedQuality: Quality    //@State var temp: Quality = .full
    
    var body: some View {
        Picker(selection: $selectedQuality ,label: Text("")) {
            ForEach(Quality.allCases) { quality in
                Text(quality.rawValue).tag(quality)
            }
        }.pickerStyle(.radioGroup).padding(5)
    }
}

#Preview {
    QualityPicker(selectedQuality: .constant(.raw))
}


