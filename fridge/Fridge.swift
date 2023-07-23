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
        private var bookmarks = [URL: Data]()
        private let KEY = "stored-bookmarks"
        
        init() {
            /// decode and rebuild possible saved bookmarks
            if let data = UserDefaults.standard.data(forKey: KEY) {
                if let bookmarks = try? JSONDecoder().decode([URL: Data].self, from: data) {
                    for (url, data) in bookmarks {
                        addFile(url, from: data)
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
            if !bookmarks.keys.contains(url) {
                addFile(url)
            }
        }
        
        func addFile(_ url: URL, from data: Data? = nil) {
            if let bookmark = data == nil ? try? Bookmark(bookmarkData: data!) : try? Bookmark(targetFileURL: url) {
                ffiles.append(FridgeFile(filename: url.lastPathComponent, url: url, bookmark: bookmark))
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
            bookmarks.removeValue(forKey: ffiles[index].url)
            ffiles.remove(at: index)
            encode()
        }
        
        func openFile(_ index: Int) {
            let _ = try? ffiles[index].bookmark.usingTargetURL { targetURL in
                NSWorkspace.shared.open(targetURL)
            }
        }
    }
}
