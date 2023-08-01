//
//  MenuButton.swift
//  Fridge
//
//  Created by Casey Miller on 2023-08-01.
//

import Foundation
import SwiftUI

struct MenuButton: View, Themeable {
    let action: () -> Void
    let text: String
    @State var hovering = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(text: String, action: @escaping () -> Void) {
        self.action = action
        self.text = text
    }
    
    var body: some View {
        Button(action: action, label: { Text(text)
                .font(.callout)
                .padding([.leading, .trailing], 5)
                .padding([.top, .bottom], 3)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(self.hovering ? primaryColor : buttonTextHoverColor)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering ? 1.015 : 1.0)
    }
}
