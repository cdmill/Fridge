//
//  fridgeApp.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import SwiftUI

@main
struct fridgeApp: App {
    @State private var index: Int = 0
    private var urls: [String: String] = [:]
    private let defaults = UserDefaults.standard
    
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
    func addFile() {}
    //        let dialog = NSOpenPanel()
    //        dialog.title = "Choose a File to Add"
    //        dialog.canChooseFiles = true
    //        dialog.canChooseDirectories = false
    //        dialog.allowsMultipleSelection = false
    //        dialog.canResolveUbiquitousConflicts = false
    //        dialog.canDownloadUbiquitousContents = true
    //        dialog.orderFrontRegardless()
    //        dialog.allowedContentTypes = [.pdf]
    //
    //        var fileChoice: URL?
    //        if dialog.runModal() == NSApplication.ModalResponse.OK {
    //            fileChoice = dialog.url
    //        } else { // Cancel was pressed
    //            return
    //        }
    //
    //        guard let url = fileChoice else { // Something went wrong
    //            return
    //        }
    //
    //        let filePath = url.absoluteString
    //        if let match = filePath.firstMatch(of: /[^\/]+\.pdf$/) {
    //            let fileName = String(match.output)
    //
    //            if urls.keys.contains(fileName) {
    //                return
    //            }
    //
    //            let file = NSMenuItem(title: fileName, action: #selector(openFile(_:)), keyEquivalent: String(index+1))
    //            menu.insertItem(file, at: index)
    //            urls[file.title] = filePath
    //            index += 1
    //            defaults.set(urls, forKey: "files")
    //        }
    //    }
    func removeFile() {}
    
    var body: some View {
        Divider()
        HStack {
            Button(action: addFile, label: {Text("Add File")} )
            Button(action: removeFile, label: {Text("RemoveFile")} )
        }
        Divider()
        Button("Quit") { NSApplication.shared.terminate(nil) }.keyboardShortcut("q")
    }
}
