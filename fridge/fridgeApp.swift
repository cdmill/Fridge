//
//  fridgeApp.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import SwiftUI
import Foundation

@main
struct fridgeApp: App {
    var body: some Scene {
        MenuBarExtra {
            fridgeMenu()
        } label: {
            let icon = NSImage(systemSymbolName: "refrigerator.fill", accessibilityDescription: "fridge")
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .black)
            let iconWithConfig = icon?.withSymbolConfiguration(config)
            Image(nsImage: iconWithConfig!)
        }
    }
}

struct fridgeMenu: View {
    @StateObject private var fridgeModel = fridge()
    private let defaults = UserDefaults.standard
    
    var body: some View {
        Divider()
        Button(action: fridgeModel.addFile, label: {Text("Add File")} )
        Button(action: fridgeModel.removeFile, label: {Text("RemoveFile")} )
        Divider()
        Button("Quit") { NSApplication.shared.terminate(nil) }.keyboardShortcut("q")
    }
}
