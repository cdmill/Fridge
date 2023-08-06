//
//  FridgeApp.swift
//  Fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import SwiftUI
import Foundation

@main
@available(macOS 13, *)
struct FridgeApp: App {
    var body: some Scene {
        MenuBarExtra {
            FridgeWindow()
        } label: {
            let icon = NSImage(systemSymbolName: "refrigerator.fill", accessibilityDescription: "Fridge")
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .black)
            let iconWithConfig = icon?.withSymbolConfiguration(config)
            Image(nsImage: iconWithConfig!)
        }.menuBarExtraStyle(.window)
    }
}
