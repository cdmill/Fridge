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
    
    var body: some View {
        VStack{
            ForEach(0...fridgeModel.items.count-1, id: \.self) { i in
                if !fridgeModel.items.isEmpty {
                    Button{fridgeModel.openFile(i)} label: {Text(fridgeModel.items[i].filename)}
                }
            }
        }
        Divider()
        Button{fridgeModel.addFile()} label: {Image(systemName: "plus.circle")}
        Button(action: fridgeModel.removeFile, label: {Text("RemoveFile")} )
        Divider()
        Button("Quit") { NSApplication.shared.terminate(nil) }
    }
}
