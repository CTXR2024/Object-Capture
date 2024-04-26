//
//  Alert.swift
//  ObjectCapture
//
//  Created by 洪聪志 on 2024/4/12.
//

import SwiftUI

struct AlertData: Identifiable {
    var id = UUID()
    
    var title: String
    var message: String = ""
    var primaryTitle: String? //hightlight button
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
        let data = AlertData(title: title, message: message ?? "", primaryTitle: primaryTitle, secondaryTitle: secondaryTitle, onPrimary: onPrimary, onSecondary: onSecondary)
        AlertTools.shared.list.append(data)
//        if data.primaryTitle == nil && data.secondaryTitle == nil {
//            AlertTools.shared.autoDismiss(data)
//        }
    }
    
    func dismiss(_ data: AlertData) {
        if let index = list.firstIndex(where: { $0.id == data.id }) {
            list.remove(at: index)
        }
    }
    
//    func autoDismiss(_ data: AlertData) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
//            if let index = list.firstIndex(where: { $0.id == data.id }) {
//                list.remove(at: index)
//            }
//        })
//    }
    
    
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
            if let primaryTitle = alertData.primaryTitle, let secondaryTitle = alertData.secondaryTitle {
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
            } else if let title = alertData.primaryTitle ?? alertData.secondaryTitle {
                Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message),
                    dismissButton: .default(Text(title), action: {
                        if alertData.primaryTitle != nil {
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
    
    
    //    func body(content: Content) -> some View {
    //        content.sheet(isPresented: $alertTools.isPresented) {
    //            VStack {
    //                ZStack {
    //                    ForEach(alertTools.list) {alertData in
    //                        VStack {
    //                            VStack(spacing: 20) {
    //                                VStack(spacing: 10) {
    //                                    Text(alertData.title)
    //                                    Text(alertData.message ?? "")
    //                                }
    //
    //                                if alertData.primaryTitle != nil || alertData.secondaryTitle != nil {
    //                                    Spacer(minLength: 50)
    //                                    if let title = alertData.primaryTitle {
    //                                        Button(action: {
    //                                            alertData.onPrimary?()
    //                                            alertTools.dismiss(alertData)
    //                                        }, label: {
    //                                            HStack {
    //                                                Text(title)
    //                                            }.frame(height: 25).frame(maxWidth: .infinity)
    //                                        })
    //                                    }
    //
    //                                    if let title = alertData.secondaryTitle{
    //                                        Button(action: {
    //                                            alertData.onSecondary?()
    //                                            alertTools.dismiss(alertData)
    //                                        }, label: {
    //                                            HStack {
    //                                                Text(title)
    //                                            }.frame(height: 25).frame(maxWidth: .infinity)
    //                                        })
    //                                    }
    //                                }
    //
    //                            }.padding(.vertical, 40).padding(.horizontal, 20)
    //                                .frame(width: 280, height: 320)
    //                                .background(Color.black).border(Color.white.opacity(0.1), width: 2)
    //                        }
    //
    //                    }
    //                }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black.opacity(0.4))
    //            }
    //
    //        }
    //    }
    
}


