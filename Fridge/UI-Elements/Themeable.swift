//
//  Themeable.swift
//  Fridge
//
//  Created by Casey Miller on 2023-08-01.
//

import Foundation
import SwiftUI

protocol Themeable {
    var colorScheme: ColorScheme { get }
}

extension Themeable {
    var primaryColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var buttonTextHoverColor: Color {
        colorScheme == .dark ? .white.opacity(0.65) : .black.opacity(0.65)
    }

    var buttonBackgroundHoverColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.15)
    }
}
