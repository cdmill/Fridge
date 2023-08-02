//
//  FileButton.swift
//  Fridge
//
//  Created by Casey Miller on 2023-08-01.
//

import Foundation
import SwiftUI

struct FileButton: View, Themeable {
    let action: () -> Void
    let isDynamic: Bool
    let text: String
    @State var hovering = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(text: String, isDynamic: Bool = true, action: @escaping () -> Void) {
        self.action = action
        self.isDynamic = isDynamic
        self.text = text
    }
    
    var body: some View {
        Button(action: action, label: { Text(text)
                .padding(.leading, 10)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(self.hovering && isDynamic ? primaryColor : buttonTextHoverColor)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering && isDynamic ? 1.015 : 1.0)
        .background(self.hovering && isDynamic ?
                    RoundedRectangle(cornerRadius: 5, style: .continuous).fill(buttonBackgroundHoverColor) :
                    RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.clear))
    }
}
