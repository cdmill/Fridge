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
        private var bookmarks = [URL: Data]()
        private let KEY = "stored-bookmarks"
        
        init() {
            /// decode and rebuild possible saved bookmarks
            if let data = UserDefaults.standard.data(forKey: KEY) {
                if let bookmarks = try? JSONDecoder().decode([URL: Data].self, from: data) {
                    for (url, data) in bookmarks {
                        addFile(url, restored: true, from: data)
                    }
                }
            }
        }
        
        func openDialog() {
            let dialog = NSOpenPanel()
            dialog.center()
            dialog.canChooseFiles = true
            dialog.canChooseDirectories = false
            dialog.allowsMultipleSelection = false
            dialog.canResolveUbiquitousConflicts = false
            dialog.canDownloadUbiquitousContents = true
            dialog.orderFrontRegardless()
            dialog.allowedContentTypes = [.pdf]
            
            guard dialog.runModal() == NSApplication.ModalResponse.OK else {
                /// cancel was pressed
                return
            }
            guard let url = dialog.url else {
                /// something went wrong
                return
            }
            addFile(url)
        }
        
        func addFile(_ url: URL, restored: Bool = false, from data: Data? = nil) {
            let filename = url.lastPathComponent
            if filesInFridge.contains(filename) {
                return
            }
            if let bookmark = restored ? try? Bookmark(bookmarkData: data!) : try? Bookmark(targetFileURL: url) {
                ffiles.append(FridgeFile(filename: filename, url: url, bookmark: bookmark))
                filesInFridge.insert(filename)
                bookmarks[url] = bookmark.bookmarkData
                encode()
            }
        }
        
        func encode() {
            if let encoded = try? JSONEncoder().encode(bookmarks) {
                UserDefaults.standard.set(encoded, forKey: KEY)
            }
        }
        
        func removeFile(_ index: Int) {
            filesInFridge.remove(ffiles[index].filename)
            ffiles.remove(at: index)
        }
        
        func openFile(_ index: Int) {
            let _ = try? ffiles[index].bookmark.usingTargetURL { targetURL in
                NSWorkspace.shared.open(targetURL)
            }
        }
    }
}
