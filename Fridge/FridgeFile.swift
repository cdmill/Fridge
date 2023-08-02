//
//  FridgeFile.swift
//  Fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation

struct FridgeFile: Codable {
    var filename: String
    var url: URL
    var bookmark: Bookmark
}
