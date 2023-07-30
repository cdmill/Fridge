//
//  Fridge.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import Foundation
import SwiftUI

extension FridgeMenu {
    @available(macOS 13, *)
    @MainActor class Fridge: ObservableObject {
        
        @Published var ffiles: [FridgeFile] = []
        private var bookmarks = [URL: Data]()
        private let KEY = "stored-bookmarks"
        
        init() {
            /// decode and rebuild possible saved bookmarks
            guard
                let data = UserDefaults.standard.data(forKey: KEY),
                let bookmarks = try? JSONDecoder().decode([URL: Data].self, from: data)
            else {
                return
            }
            for (url, data) in bookmarks {
                addFile(url, from: data)
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
            dialog.allowedContentTypes = [.pdf, .plainText, .text,
                                          .application, .executable,
                                          .script, .image]
            
            guard
                dialog.runModal() == NSApplication.ModalResponse.OK,
                let url = dialog.url
            else {
                /// cancel was pressed or something went wrong
                return
            }
            if !bookmarks.keys.contains(url) {
                addFile(url)
            }
        }
        
        func addFile(_ url: URL, from data: Data? = nil) {
            guard let bookmark = (data == nil) ?
                    try? Bookmark(targetFileURL: url) :
                    try? Bookmark(bookmarkData: data!)
            else {
                return
            }
            let filename = getFilename(from: url)
            ffiles.addFridgeFile(FridgeFile(filename: filename, url: url, bookmark: bookmark))
            ffiles.sort(by: { $0.filename.lowercased() < $1.filename.lowercased()} )
            bookmarks[url] = bookmark.bookmarkData
            encode()
        }
        
        func removeFile(_ index: Int) {
            bookmarks.removeValue(forKey: ffiles[index].url)
            ffiles.remove(at: index)
            encode()
        }
        
        func openFile(_ index: Int) {
            let returnedState = try? ffiles[index].bookmark.usingTargetURL { targetURL in
                NSWorkspace.shared.open(targetURL)
            }
            if returnedState?.bookmarkState == .invalid {
                removeFile(index)
            }
            // NOTE: not currently handling stale URLs
        }
        
        private func encode() {
            if let encoded = try? JSONEncoder().encode(bookmarks) {
                UserDefaults.standard.set(encoded, forKey: KEY)
            }
        }
        
        private func getFilename(from url: URL) -> String {
            var filename = url.lastPathComponent
            if filename.hasSuffix(".app") {
                filename.removeLast(4)
            }
            if filename.count > 28 {
                filename = String(filename.dropLast(filename.count - 28))
                filename.append("...")
            }
            return filename
        }
    }
}

extension Array where Element == FridgeFile {
    
    var hasAvailableSlots: Bool {
        get {
            self.count != 4
        }
    }
    
    mutating func addFridgeFile(_ ffile: FridgeFile) {
        /// limit number of FridgeFiles in Fridge
        if self.count < 4 {
            self.append(ffile)
        }
    }
}
