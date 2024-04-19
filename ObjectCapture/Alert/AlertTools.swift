//
//  Alert.swift
//  ObjectCapture
//
//  Created by 洪聪志 on 2024/4/12.
//

import SwiftUI

struct AlertData: Identifiable {
    var id = UUID().uuidString
    var isPresented = true
    var title: String
    var message: String?
    var primaryTitle: String?
    var secondaryTitle: String?
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
    
    static func show(_ title: String, message: String? = nil, primaryTitle: String? = nil, secondaryTitle: String? = nil, onPrimary: (() -> Void)? = nil, onSecondary: (() -> Void)? = nil) {
        let data = AlertData(title: title, message: message, primaryTitle: primaryTitle, secondaryTitle: secondaryTitle, onPrimary: onPrimary, onSecondary: onSecondary)
        AlertTools.shared.list.append(data)
        if data.primaryTitle == nil && data.secondaryTitle == nil {
            AlertTools.shared.autoDismiss(data)
        }
    }
    
    func dismiss(_ data: AlertData) {
        if let index = list.firstIndex(where: { $0.id == data.id }) {
            list.remove(at: index)
        }
    }
    
    func autoDismiss(_ data: AlertData) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
            if let index = list.firstIndex(where: { $0.id == data.id }) {
                list.remove(at: index)
            }
        })
    }
    
    
}

extension View {
    public func customAlert() -> some View {
        return self.modifier(CustomAlertModifier())
    }
}

struct CustomAlertModifier: ViewModifier {
    @ObservedObject var alertTools: AlertTools = AlertTools.shared
    
    func body(content: Content) -> some View {
        
        content.sheet(isPresented: $alertTools.isPresented) {
            ZStack {
                
                ForEach(alertTools.list) {alertData in
                    let index = alertTools.list.firstIndex(where: { $0.id == alertData.id })
                    
                    VStack {
                        VStack(spacing: 20) {
                            VStack(spacing: 10) {
                                Text(alertData.title)
                                Text(alertData.message ?? "")
                            }
                            
                            
                            if alertData.primaryTitle != nil || alertData.secondaryTitle != nil {
                                Spacer(minLength: 50)
                                if let title = alertData.primaryTitle {
                                    Button(action: {
                                        alertData.onPrimary?()
                                        alertTools.dismiss(alertData)
                                    }, label: {
                                        HStack {
                                            Text(title)
                                        }.frame(height: 25).frame(maxWidth: .infinity)
                                    })
                                }
                                
                                if let title = alertData.secondaryTitle{
                                    Button(action: {
                                        alertData.onSecondary?()
                                        alertTools.dismiss(alertData)
                                    }, label: {
                                        HStack {
                                            Text(title)
                                        }.frame(height: 25).frame(maxWidth: .infinity)
                                    })
                                }
                            }
                            
                        }.padding(.vertical, 40).padding(.horizontal, 20)
                            .frame(width: 280)
                            .background(Color.black).border(Color.white.opacity(0.1), width: 2)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black)
                    
                }
            }
            
        }
    }
    
}


