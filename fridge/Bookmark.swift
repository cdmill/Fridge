//
//  Bookmark.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import UniformTypeIdentifiers

@available(macOS 10.12, *)
public class Bookmark: Codable {
    enum CodingKeys: CodingKey {
        case bookmarkData
    }

    /// Bookmark-specific errors
    public enum BookmarkError: Error {
        case invalidFileURL
        case cantAccessTargetUTType
        case invalidTargetUTType
        case cantAccessSecurityScopedResource
        case bookmarkIsStaleNeedsRebuild
    }

    /// The bookmark's state.
    public enum State {
        /// The bookmark is valid (ie. the target url is resolvable)
        case valid
        /// The bookmark needs to be rebuilt (eg. the original target file has been moved or renamed)
        case stale
        /// The targetURL cannot be resolved, and as such the bookmark is invalid
        case invalid
    }

    /// The result of retrieving a URL from a bookmark
    public struct TargetURL {
        /// The state of the bookmark
        public let state: Bookmark.State
        /// The target URL for the bookmark
        public let url: URL
        public init(result: Bookmark.State, url: URL) {
            self.state = result
            self.url = url
        }
    }

    /// The raw bookmark data
    public let bookmarkData: Data

    /// A base64 string representation for the bookmark data
    public private(set) lazy var bookmarkBase64: String = self.bookmarkData.base64EncodedString()

    /// Returns the bookmark state. If stale, your app should create a new bookmark use it in place of any stored copies
    /// of the existing bookmark.
    ///
    /// If the URL is no longer valid (eg the target file can no longer be found, returns .invalid)
    public var state: State {
        guard let state = try? targetURL().state else {
            return .invalid
        }
        return state
    }

    /// Returns true if the bookmark was created with security scope (creation options contained `.withSecurityScope`)
    /// and the target for the bookmark is still resolvable. Returns `nil` if the bookmark is no longer resolvable.
    ///
    /// Note: iOS bookmarks are ALWAYS security scoped.
    public var isSecurityScoped: Bool? {
        guard self.state == .invalid else {
            return nil
        }

        guard
            let result = try? targetURL(options: .withSecurityScope),
            result.state != .invalid
        else {
            return false
        }
        return true
    }

    /// Create a bookmark object from a target file url
    /// - Parameters:
    ///   - targetFileURL: The target file url to bookmark
    ///   - includingResourceValuesForKeys: Resource keys to store in the bookmark
    ///   - options: Bookmark creation options
    public init(
        targetFileURL: URL,
        includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil,
        options: URL.BookmarkCreationOptions = []
    ) throws {
        guard targetFileURL.isFileURL else {
            throw BookmarkError.invalidFileURL
        }

        self.bookmarkData = try targetFileURL.bookmarkData(
            options: options,
            includingResourceValuesForKeys: keys,
            relativeTo: nil
        )
    }
    
    /// Create a bookmark object from raw bookmark data
    /// - Parameter bookmarkData: The bookmark data
    /// - Parameter validate: Validate the bookmark data is valid and the target url is resolvable.
    public init(bookmarkData: Data, validate: Bool = false) throws {
        if validate {
            var isStale = false
            let _ = try URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], bookmarkDataIsStale: &isStale)
        }
        self.bookmarkData = bookmarkData
    }
}

// MARK: - Accessing the bookmark's target

public extension Bookmark {
    /// Returns the bookmark's target url
    /// - Parameters:
    ///   - options: Additional bookmark resolution options (See: [Bookmark Resolution Options](https://developer.apple.com/documentation/foundation/nsurl/bookmarkresolutionoptions)
    /// - Returns: A `TargetURL` object consisting of the bookmark's state and the target url
    @inlinable func targetURL(
        options: NSURL.BookmarkResolutionOptions = []
    ) throws -> TargetURL {
        var isStale = false
        let url = try URL(resolvingBookmarkData: self.bookmarkData, options: options, bookmarkDataIsStale: &isStale)
        return TargetURL(result: isStale ? .stale : .valid, url: url)
    }
    
    /// Access the bookmark's target url in a block scope
    /// - Parameters:
    ///   - options: Additional bookmark resolution options
    ///   - scopedBlock: The block to perform.
    ///                  If securityScoped is true, the url will automatically be wrapped in
    ///                  `startAccessingSecurityScopedResource` and `stopAccessingSecurityScopedResource`
    /// - Returns: A tuple consisting of the bookmark's state and the `scopedBlock`'s return value
    func usingTargetURL<ReturnType>(
        options: NSURL.BookmarkResolutionOptions = [],
        _ scopedBlock: (URL) -> ReturnType
    ) throws -> (bookmarkState: Bookmark.State, result: ReturnType) {
        let urlResult = try targetURL(options: options)
        let securityScoped = options.contains(.withSecurityScope)
        if securityScoped {
            guard urlResult.url.startAccessingSecurityScopedResource() == true else {
                throw BookmarkError.cantAccessSecurityScopedResource
            }
        }
        defer { if securityScoped { urlResult.url.stopAccessingSecurityScopedResource() } }
        return (urlResult.state, scopedBlock(urlResult.url))
    }
}
