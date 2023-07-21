//
//  Bookmark.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation

class Bookmark {
    var bookmarks = [URL: Data]()
    private let KEY = "stored-bookmarks"
    
    func restore() {
        if let data = UserDefaults.standard.data(forKey: KEY) {
            do {
                bookmarks = try JSONDecoder().decode([URL: Data].self, from: data)
            } catch {
               print("Error while decoding data: ", error)
            }
        }
    }
    
    func isPermissionGranted(for url: URL) -> Bool {
        if let data = bookmarks[url] {
            var bookmarkDataIsStale: ObjCBool = false
            
            do {
                let url = try (NSURL(
                    resolvingBookmarkData: data,
                    options: [.withoutUI, .withSecurityScope],
                    relativeTo: nil,
                    bookmarkDataIsStale: &bookmarkDataIsStale) as URL
                )
                if bookmarkDataIsStale.boolValue {
                    NSLog("WARNING stale security bookmark")
                    return false
                }
                return url.startAccessingSecurityScopedResource()
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
        
    func save(_ url: URL) {
        do {
            let data = try url.bookmarkData(
                options: NSURL.BookmarkCreationOptions.withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            bookmarks[url] = data
            if let encoded = try? JSONEncoder().encode(bookmarks) {
                UserDefaults.standard.set(encoded, forKey: KEY)
            }
        } catch {
            NSLog("Error storing bookmarks")
        }
    }
}

