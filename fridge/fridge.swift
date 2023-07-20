//
//  fridge.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import Foundation
import SwiftUI

extension fridgeMenu {
    @MainActor class fridge: ObservableObject {
        
        @Published var urls: [String: String] = [:]
        private let defaults = UserDefaults.standard
        
        func addFile() {
            let dialog = NSOpenPanel()
            dialog.title = "Choose a File to Add"
            dialog.canChooseFiles = true
            dialog.canChooseDirectories = false
            dialog.allowsMultipleSelection = false
            dialog.canResolveUbiquitousConflicts = false
            dialog.canDownloadUbiquitousContents = true
            dialog.orderFrontRegardless()
            dialog.allowedContentTypes = [.pdf]
            
            var fileChoice: URL?
            if dialog.runModal() == NSApplication.ModalResponse.OK {
                fileChoice = dialog.url
            } else { // Cancel was pressed
                return
            }
            
            guard let url = fileChoice else { // Something went wrong
                return
            }
            
            let filePath = url.absoluteString
            if let match = filePath.firstMatch(of: /[^\/]+\.pdf$/) {
                let fileName = String(match.output)
                
                if urls.keys.contains(fileName) {
                    return
                }
                
                urls[fileName] = filePath
                defaults.set(urls, forKey: "files")
            }
        }
        
        func removeFile() {}
        
        func openFile(_ sender: NSMenuItem) {
            guard let filePath = urls[sender.title] else { return }
            if let url = URL(string: filePath) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
