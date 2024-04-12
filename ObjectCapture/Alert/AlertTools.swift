//
//  Alert.swift
//  ObjectCapture
//
//  Created by 洪聪志 on 2024/4/12.
//

import SwiftUI

class AlertTools: ObservableObject {
    static let shared = AlertTools()
    private init() {}
    
    @Published var isPresented: Bool = false
    @Published var title: String = ""
    @Published var message: String? = nil
    @Published var onPrimary: (() -> Void)? = nil
    @Published var onSecondary: (() -> Void)? = nil
    
    func show(_ title: String, message: String? = nil, onPrimary: (() -> Void)? = nil, onSecondary: (() -> Void)? = nil) {
        self.isPresented = true
        self.title = title
        self.message = message
        self.onPrimary = onPrimary
        self.onSecondary = onSecondary
    }
    
    
}
