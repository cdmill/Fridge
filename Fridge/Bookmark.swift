//
//  Bookmark.swift
//  Fridge
//
//  Modified by Casey Miller 2023-07-24 from Bookmark.swift https://github.com/dagronf/Bookmark.git
//

import Foundation
import UniformTypeIdentifiers

@available(macOS 13, *)
public class Bookmark: Codable {

    /// Bookmark-specific errors.
    public enum BookmarkError: Error {
        /// The file URL cannot be resolved.
        case invalidFileURL
        /// Unable to access security scoped resource.
        case cantAccessSecurityScopedResource
        /// The bookmark needs to be rebuilt (i.e., original targetURL is stale).
        case bookmarkIsStaleNeedsRebuild
    }

    /// The bookmark's state.
    public enum State {
        /// The bookmark is valid (ie. the target url is resolvable).
        case valid
        /// The bookmark needs to be rebuilt (eg. the original target file has been moved or renamed).
        case stale
        /// The targetURL cannot be resolved, and as such the bookmark is invalid.
        case invalid
    }

    /// The URL retrieved from a bookmark.
    public struct TargetURL {
        public let state: Bookmark.State
        public let url: URL
        public init(result: Bookmark.State, url: URL) {
            self.state = result
            self.url = url
        }
    }

    /// The raw bookmark data.
    public let bookmarkData: Data

    /// The state for any given bookmark. 
    public var state: State {
        guard let state = try? targetURL().state else {
            return .invalid
        }
        return state
    }

    /// Create a bookmark from a URL. Checks if target file URL resolves to a valid file.
    public init(
        targetFileURL: URL,
        includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil,
        options: URL.BookmarkCreationOptions = [.withSecurityScope, .securityScopeAllowOnlyReadAccess]
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
    
    /// Create a bookmark object from raw bookmark data.
    public init(bookmarkData: Data, validate: Bool = true) throws {
        if validate {
            var isStale = false
            let _ = try URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], bookmarkDataIsStale: &isStale)
        }
        self.bookmarkData = bookmarkData
    }
}

// MARK: - Accessing the bookmark's target

public extension Bookmark {
    /// Sets and returns the bookmark's target, including its state and its resolved URL.
    ///
    /// - Parameter options: The options considered when resolving security-scoped bookmark data.
    /// - Returns: The TargetURL struct associated with the bookmark's target.
    @inlinable func targetURL(
        options: NSURL.BookmarkResolutionOptions = [.withSecurityScope]
    ) throws -> TargetURL {
        var isStale = false
        let url = try URL(resolvingBookmarkData: self.bookmarkData, options: options, bookmarkDataIsStale: &isStale)
        return TargetURL(result: isStale ? .stale : .valid, url: url)
    }
    
    /// Accesses a bookmark's target URL and returns its state and URL.
    ///
    /// - Parameters:
    ///   - options: The options considered when resolving security-scoped bookmark data. 
    ///   - scopedBlock: Dummy variable used to cast URL type to specified return type.  
    /// - Returns: The tuple containing the accessed TargetURL's state and URL. 
    func usingTargetURL<ReturnType>(
        options: NSURL.BookmarkResolutionOptions = [.withSecurityScope],
        _ scopedBlock: (URL) -> ReturnType
    ) throws -> (bookmarkState: Bookmark.State, result: ReturnType) {
        let urlResult = try targetURL()
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
