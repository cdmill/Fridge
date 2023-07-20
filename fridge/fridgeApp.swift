//
//  fridgeApp.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import SwiftUI

struct fridgeApp: App {
    @State private var index: Int = 0
    private var urls: [String: String] = [:]
    private let defaults = UserDefaults.standard
    
    var body: some Scene {        
        MenuBarExtra("Fridge", systemImage: "refrigerator.fill") {
            Divider()
            HStack {
                Button("Add File") {}
                Button("Remove File") {}
            }
            Divider()
            Button("Quit") {}.keyboardShortcut("q")
        }
    }
}
