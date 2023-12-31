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
    let isDynamic: Bool
    let systemName: String
    @State var hovering = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(systemName: String, isDynamic: Bool = true, action: @escaping () -> Void) {
        self.action = action
        self.isDynamic = isDynamic
        self.systemName = systemName
    }
    
    var body: some View {
        Button(action: action, label: { Image(systemName: systemName).font(.headline)
                .opacity((self.hovering && isDynamic) || (!isDynamic) ? 1.0 : 0.5)
                .foregroundColor(primaryColor)
                .frame(width: 20, height: 20, alignment: .center)
                .padding(2)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous).fill(self.hovering ? buttonBackgroundHoverColor : Color.clear))
    }
}
