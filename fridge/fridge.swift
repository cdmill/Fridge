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
        
        @Published var items: [fridgeItem] = []
        private var files: Set<String> = []
        private var index = 0
        
        struct fridgeItem: Codable {
            let url: URL
            let filename: String
        }
        
        init() {
            
            if let data = UserDefaults.standard.data(forKey: "StoredFiles") {
                do {
                    items = try JSONDecoder().decode([fridgeItem].self, from: data)
                } catch {
                   print("Unable to decode data.")
                }
            }
            
            index = items.count
        }
        
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
                
                if files.contains(fileName) {
                    return
                }
                
                items.append(fridgeItem(url: url, filename: fileName))
                files.insert(fileName)
                if let encoded = try? JSONEncoder().encode(items) {
                    UserDefaults.standard.set(encoded, forKey: "StoredFiles")
                }
                index += 1
            }
        }
        
        func removeFile() {
            
        }
        
        func openFile(_ i: Int) {
            let url = items[i].url
            NSWorkspace.shared.open(url)
        }
    }
}
