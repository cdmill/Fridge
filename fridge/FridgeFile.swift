//
//  FridgeFile.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation

struct FridgeFile: Codable {
    let filename: String
    var url: URL
    var bookmark: Bookmark
}
