//
//  ContentView.swift
//  ObjectCapture
//
//  Created by jayjiang on 22/03/2024.
//

import SwiftUI

enum QualityType {
    case Reduced
    case Medium
    case Full
    case Raw
}

struct CheckboxButtonData: Identifiable {
    let id = UUID().uuidString
    let title: String
    let type: QualityType
}

struct ContentView: View {
    
    @State private var isChecked = false
    @State private var selectedType = QualityType.Raw
    
    private var qualityArr = [
        CheckboxButtonData(title: "Reduced", type: QualityType.Reduced),
        CheckboxButtonData(title: "Medium", type: QualityType.Medium),
        CheckboxButtonData(title: "Full", type: QualityType.Full),
        CheckboxButtonData(title: "Raw", type: QualityType.Raw)
    ]
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                leftView
                rightView
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    var leftView: some View {
        VStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Files")
                        .font(.headline)
                        .frame(alignment: .leading)
                    FolderSelectionView(inputBlock: {}, outpitBlock: {})
                    Divider()
                        .foregroundColor(.white)
                }
                Button(action: {}) {
                    Text("Preview")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Final Processing Quality")
                    Spacer()
                }
                finalProcessingQualityList
                Button(action: {}) {
                    Text("Create Model")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }
        }.frame(width: 220).padding(.all, 10).background(Color(red: 75/255, green: 75/255, blue: 75/255))
    }
    
    var rightView: some View {
        VStack {
            Color.white
        }
    }
    
    var finalProcessingQualityList: some View {
        VStack(alignment: .leading) {
            ForEach(qualityArr) {data in
                CheckboxButton(data: data, isChecked: data.type == selectedType, onClick: { type in
                    selectedType = type
                })
            }
        }
    }
    
    
    struct CheckboxButton: View {
        let data: CheckboxButtonData
        var isChecked = false
        var onClick: (_ type: QualityType) -> Void
        var body: some View {
            HStack(spacing: 8) {
                CircleCheckboxView(isChecked: isChecked)
                Text(data.title)
            }.onTapGesture {
                onClick(data.type)
            }
        }
    }
    
    
    
    
}




#Preview {
    ContentView()
}

