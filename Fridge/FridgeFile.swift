//
//  FridgeFile.swift
//  Fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation

struct FridgeFile: Codable, Comparable {
    
    var filename: String
    var url: URL
    var bookmark: Bookmark
    
    static func < (lhs: FridgeFile, rhs: FridgeFile) -> Bool {
        return lhs.filename.lowercased() < rhs.filename.lowercased()
    }
    
    static func == (lhs: FridgeFile, rhs: FridgeFile) -> Bool {
        return lhs.filename == rhs.filename
    }
}
