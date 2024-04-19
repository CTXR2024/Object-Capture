//
//  Alert.swift
//  ObjectCapture
//
//  Created by 洪聪志 on 2024/4/12.
//

import SwiftUI

struct AlertData: Identifiable {
    var id = UUID().uuidString
    
    var title: String
    var message: String?
    var onPrimary: (() -> Void)? = nil
    var onSecondary: (() -> Void)? = nil
}

class AlertTools: ObservableObject {
    static let shared = AlertTools()
    private init() {}
    
    @Published var list: [AlertData] = [] {
        didSet {
            if list.isEmpty {
                isPresented = false
            } else if isPresented == false {
                isPresented = true
            }
        }
    }
    
    @Published var isPresented: Bool = false

    static func show(_ title: String, message: String? = nil, onPrimary: (() -> Void)? = nil, onSecondary: (() -> Void)? = nil) {
        let data = AlertData(title: title, message: message, onPrimary: onPrimary, onSecondary: onSecondary)
        AlertTools.shared.list.append(data)
    }
    
    
}

extension View {
    public func customAlert() -> some View {
        let alertTools = AlertTools.shared
        return self.modifier(CustomAlertModifier(alertTools: alertTools))
    }
}

struct CustomAlertModifier: ViewModifier {
    @ObservedObject var alertTools: AlertTools
    
    func body(content: Content) -> some View {
        content.sheet(isPresented: $alertTools.isPresented) {
            ZStack {
                ForEach(alertTools.list) {alertData in
                    VStack {
                        Text(alertData.title)
                        Text(alertData.message ?? "")
                        Spacer()
                        Button("Close") {
                            alertData.onPrimary?()
                            if let index = alertTools.list.firstIndex(where: { $0.id == alertData.id }) {
                                alertTools.list.remove(at: index)
                            }
                        }
                        
//                        Button("Secondary Button") {
//                            alertData.onSecondary?()
//                            
//                            if let index = alertTools.list.firstIndex(where: { $0.id == alertData.id }) {
//                                alertTools.list.remove(at: index)
//                            }
//                        }
                        
                    }.padding(.vertical, 40).padding(.horizontal, 20)
                    .frame(width: 200, height: 300)
                    .background(Color.black)
                }
            }.background(Color.red)
            
        }
    }
}


