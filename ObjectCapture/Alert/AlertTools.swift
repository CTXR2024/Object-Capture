//
//  Alert.swift
//  ObjectCapture
//
//  Created by Kerwin.Hong on 2024/4/12.
//

import SwiftUI

struct AlertData: Identifiable {
    var id = UUID()
    
    var title: String
    var message: String = ""
    var primaryButtonText: String? //hightlight button
    var secondaryTitle: String?
    var onPrimary: (() -> Void)? = nil
    var onSecondary: (() -> Void)? = nil
}

class AlertTools: ObservableObject {
    static let shared = AlertTools()
    private init() {}
    
    @Published var list: [AlertData] = [] {
        didSet {
            isPresented = !list.isEmpty
        }
    }
    
    @Published var isPresented: Bool = false
    
    static func show(_ title: String, message: String? = nil, primaryTitle: String? = nil, secondaryTitle: String? = nil, onPrimary: (() -> Void)? = nil, onSecondary: (() -> Void)? = nil) {
        let data = AlertData(title: title, message: message ?? "", primaryButtonText: primaryTitle, secondaryTitle: secondaryTitle, onPrimary: onPrimary, onSecondary: onSecondary)
        AlertTools.shared.list.append(data)
    }
    
    func dismiss(_ data: AlertData) {
        if let index = list.firstIndex(where: { $0.id == data.id }) {
            list.remove(at: index)
        }
    }
}

extension View {
    public func customAlert() -> some View {
        return self.modifier(CustomAlertModifier())
    }
}

struct CustomAlertModifier: ViewModifier {
    @ObservedObject var alertTools = AlertTools.shared
    
    func body(content: Content) -> some View {
        content.alert(item: Binding<AlertData?>(
            get: { alertTools.list.first },
            set: { _ in dismissAlert() }
        )) { alertData in
            if let primaryTitle = alertData.primaryButtonText, let secondaryTitle = alertData.secondaryTitle {
                Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message),
                    primaryButton: .default(Text(primaryTitle), action: {
                        alertData.onPrimary?()
                    }),
                    secondaryButton: .default(Text(secondaryTitle), action: {
                        alertData.onSecondary?()
                    })
                )
            } else if let title = alertData.primaryButtonText ?? alertData.secondaryTitle {
                Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message),
                    dismissButton: .default(Text(title), action: {
                        if alertData.primaryButtonText != nil {
                            alertData.onPrimary?()
                        }
                        if alertData.secondaryTitle != nil {
                            alertData.onSecondary?()
                        }
                    })
                )
            } else {
                Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message)
                )
            }
        }
    }
    
    
    private func dismissAlert() {
        if let alertData = alertTools.list.first {
            alertTools.dismiss(alertData)
        }
    }
}


