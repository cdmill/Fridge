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
    let systemName: String
    let text: String
    @State var hovering = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(text: String, systemName: String, action: @escaping () -> Void) {
        self.action = action
        self.systemName = systemName
        self.text = text
    }
    
    var body: some View {
        HStack {
            Button(action: action, label: { Text(text)
                    .font(.callout)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(self.hovering ? primaryColor : buttonTextHoverColor)
            })
            .buttonStyle(.borderless)
            .onHover{ hover in hovering = hover }
            .scaleEffect(self.hovering ? 1.015 : 1.0)
            
            Image(systemName: systemName)
                .foregroundStyle(self.hovering ? primaryColor : buttonTextHoverColor)
                .scaleEffect(self.hovering ? 1.015 : 1.0)
        }
    }
}
