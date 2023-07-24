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
//        @Published var fgroups: [[FridgeFile]] = []
//        public var usedSlots: Int {ffiles.count + fgroups.count}
        private var bookmarks = [URL: Data]()
        private let KEY = "stored-bookmarks"
        
        init() {
            /// decode and rebuild possible saved bookmarks
            guard let data = UserDefaults.standard.data(forKey: KEY) else { return }
            if let bookmarks = try? JSONDecoder().decode([URL: Data].self, from: data) {
                for (url, data) in bookmarks {
                    addFile(url, from: data)
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
            guard let bookmark = data == nil ? try? Bookmark(targetFileURL: url) : try? Bookmark(bookmarkData: data!) else {
                return
            }
            ffiles.append(FridgeFile(filename: url.lastPathComponent, url: url, bookmark: bookmark))
            ffiles.sort(by: { $0.filename.lowercased() < $1.filename.lowercased()} )
            bookmarks[url] = bookmark.bookmarkData
            encode()
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
            let bookmark = try? ffiles[index].bookmark.usingTargetURL { targetURL in
                NSWorkspace.shared.open(targetURL)
            }
            if bookmark?.bookmarkState == .invalid || bookmark?.bookmarkState == .stale {
                removeFile(index)
            }
        }
    }
}
