//
//  Fridge.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import Foundation
import SwiftUI

extension FridgeMenu {
    @MainActor class Fridge: ObservableObject {
        
        @Published var ffiles: [FridgeFile] = []
        private var filesInFridge: Set<String> = []
        private let bookmark = Bookmark()
        
        init() {
            bookmark.restore()
            for url in bookmark.bookmarks.keys {
               addFile(url)
            }
        }
        
        func openDialog() {
            let dialog = NSOpenPanel()
            dialog.title = "Choose a File to Add"
            dialog.canChooseFiles = true
            dialog.canChooseDirectories = false
            dialog.allowsMultipleSelection = false
            dialog.canResolveUbiquitousConflicts = false
            dialog.canDownloadUbiquitousContents = true
            dialog.orderFrontRegardless()
            dialog.allowedContentTypes = [.pdf]
            
            guard dialog.runModal() == NSApplication.ModalResponse.OK else {
                // Cancel was pressed
                return
            }
            guard let url = dialog.url else {
                // Something went wrong
                return
            }
            addFile(url)
            saveFile(url)
        }
        
        func addFile(_ url: URL) {
            let fileName = url.lastPathComponent
            
            if filesInFridge.contains(fileName) {
                return
            }
            ffiles.append(FridgeFile(filename: fileName, url: url))
            filesInFridge.insert(fileName)
        }
        
        func saveFile(_ url: URL) {
            bookmark.save(url)
        }
        
        func removeFile() {
            
        }
        
        func openFile(_ i: Int) {
            let url = ffiles[i].url
            if bookmark.isPermissionGranted(for: url) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
