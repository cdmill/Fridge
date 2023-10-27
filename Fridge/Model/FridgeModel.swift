//
//  Fridge.swift
//  Fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import Foundation
import SwiftUI

final class FridgeModel: ObservableObject {

    @Published var ffiles: [FridgeFile] = []
    @Published var fgroups: [[FridgeFile]] = []
    private var bookmarks = [URL: Data]()
    private let KEY = "stored-bookmarks"

    init() {
        /// decode and rebuild saved bookmarks, if any
        guard
            let storedBookmarks = UserDefaults.standard.data(forKey: KEY),
            let bookmarks = try? JSONDecoder().decode([URL: Data].self, from: storedBookmarks)
        else {
            return
        }
        for (url, bookmarkData) in bookmarks {
            addFile(url: url, from: bookmarkData)
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
            addFile(url: url)
        }
    }

    func addFile(url: URL) {
        guard let bookmark = try? Bookmark(targetFileURL: url)
        else {
            return
        }
        addFileHelper(url: url, bookmark: bookmark)
    }

    func addFile(url: URL, from data: Data) {
        guard let bookmark = try? Bookmark(bookmarkData: data)
        else {
            return
        }
        addFileHelper(url: url, bookmark: bookmark)
    }

    private func addFileHelper(url: URL, bookmark: Bookmark) {
        let filename = getFilename(from: url)
        ffiles.addFridgeFile(FridgeFile(filename: filename, url: url, bookmark: bookmark))
        ffiles.sort(by: { $0 < $1 })
        bookmarks[url] = bookmark.bookmarkData
        encode()
    }

    func removeFile(_ index: Int) {
        bookmarks.removeValue(forKey: ffiles[index].url)
        ffiles.remove(at: index)
        encode()
    }

    func openFile(_ index: Int) {
        let bookmark = ffiles[index].bookmark
        let returnedState = try? bookmark.usingTargetURL { targetURL in
            NSWorkspace.shared.open(targetURL)
        }
        if returnedState?.bookmarkState == .invalid {
            removeFile(index)
        }
        else if returnedState?.bookmarkState == .stale {
            // NOTE: not currently handling stale URLs
            // TODO:
            //      Display message that file has been renamed or moved
            //      In message dialog, include buttons to readd file or to cancel
        }
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
