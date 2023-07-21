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
            let icon = NSImage(systemSymbolName: "refrigerator.fill", accessibilityDescription: "fridge")
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .black)
            let iconWithConfig = icon?.withSymbolConfiguration(config)
            Image(nsImage: iconWithConfig!)
        }
    }
}

struct FridgeMenu: View {
    @StateObject private var fridgeModel = Fridge()
    
    var body: some View {
        VStack{
            ForEach(0..<fridgeModel.ffiles.count, id: \.self) { i in
                if !fridgeModel.ffiles.isEmpty {
                    Button{fridgeModel.openFile(i)} label: {Text(fridgeModel.ffiles[i].filename)}
                }
            }
        }
        Divider()
        Button{fridgeModel.openDialog()} label: {Image(systemName: "plus.circle")}
//        Button(action: fridgeModel.removeFile, label: {Text("RemoveFile")} )
        Divider()
        Button("Quit") { NSApplication.shared.terminate(nil) }
    }
}
