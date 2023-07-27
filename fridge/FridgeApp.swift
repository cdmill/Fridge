//
//  FridgeApp.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import SwiftUI
import Foundation

@main
struct FridgeApp: App {
    var body: some Scene {
        MenuBarExtra {
            FridgeMenu()
        } label: {
            let icon = NSImage(systemSymbolName: "refrigerator.fill", accessibilityDescription: "Fridge")
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .black)
            let iconWithConfig = icon?.withSymbolConfiguration(config)
            Image(nsImage: iconWithConfig!)
        }.menuBarExtraStyle(.window)
    }
}
