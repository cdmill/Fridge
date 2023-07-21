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
            if let data = UserDefaults.standard.data(forKey: KEY) {
                do {
                    bookmarks = try JSONDecoder().decode([URL: Data].self, from: data)
                    for (url, data) in bookmarks {
                        let restored = try Bookmark(bookmarkData: data)
                        let filename = url.lastPathComponent
                        ffiles.append(FridgeFile(filename: filename, url: url, bookmark: restored))
                        filesInFridge.insert(filename)
                    }
                } catch {
                    print("Error while decoding data:", error)
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
                // Cancel was pressed
                return
            }
            guard let url = dialog.url else {
                // Something went wrong
                return
            }
            addFile(url)
        }
        
        func addFile(_ url: URL) {
            let filename = url.lastPathComponent
            if filesInFridge.contains(filename) {
                return
            }
            do {
                let bookmark = try Bookmark(targetFileURL: url)
                ffiles.append(FridgeFile(filename: filename, url: url, bookmark: bookmark))
                filesInFridge.insert(filename)
                bookmarks[url] = bookmark.bookmarkData
                encode()
            } catch {
                print("Error saving data:", error)
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
            do {
                _ = try ffiles[index].bookmark.usingTargetURL { targetURL in
                    NSWorkspace.shared.open(targetURL)
                    
                }
            } catch {
                print("Error opening file: ", error)
            }
        }
    }
}
