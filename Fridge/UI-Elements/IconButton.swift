//
//  IconButton.swift
//  Fridge
//
//  Created by Casey Miller on 2023-08-01.
//

import Foundation
import SwiftUI

struct IconButton: View, Themeable {
    let action: () -> Void
    let fontWeight: Font
    let isDynamic: Bool
    let foreground: Color
    let systemName: String
    var unfocusedOpacity: Double { foreground == primaryColor ? 0.5 : 0.8 }
    @State var hovering = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(systemName: String, color foreground: Color, isDynamic: Bool = true, fontWeight: Font = .headline, action: @escaping () -> Void) {
        self.action = action
        self.fontWeight = fontWeight
        self.foreground = foreground
        self.isDynamic = isDynamic
        self.systemName = systemName
    }
    
    var body: some View {
        Button(action: action,
               label: { Image(systemName: systemName).font(fontWeight)
                .opacity((self.hovering && isDynamic) || (!isDynamic) ? 1.0 : unfocusedOpacity)
                .foregroundColor(foreground)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering ? 1.075 : 1.0)
    }
}
