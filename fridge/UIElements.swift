//
//  UIElements.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-28.
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
    
    var buttonTextColor: Color {
        colorScheme == .dark ? .white.opacity(0.65) : .black.opacity(0.65)
    }
    
    var buttonHoverColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.15)
    }
}

// MARK: Button and Popover definitions

struct IconButton: View, Themeable {
    let action: () -> Void
    let foreground: Color
    let isDynamic: Bool
    let systemName: String
    @State var hovering = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(systemName: String, color foreground: Color, isDynamic: Bool = true, action: @escaping () -> Void) {
        self.action = action
        self.foreground = foreground
        self.isDynamic = isDynamic
        self.systemName = systemName
    }
    
    var body: some View {
        Button(action: action,
               label: { Image(systemName: systemName)
                .opacity((self.hovering && isDynamic) || (!isDynamic) ? 1.0 : 0.5)
                .foregroundColor(foreground)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering ? 1.1 : 1.0)
    }
}

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
                .padding([.top, .bottom], 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(self.hovering && isDynamic ? primaryColor : buttonTextColor)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering && isDynamic ? 1.015 : 1.0)
        .background(self.hovering && isDynamic ?
                    RoundedRectangle(cornerRadius: 5, style: .continuous).fill(buttonHoverColor) :
                    RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.clear))
    }
}

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
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(self.hovering ? primaryColor : buttonTextColor)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering ? 1.015 : 1.0)
    }
}

struct PopoverMenu: View {
    let firstOption: MenuButton
    let secondOption: MenuButton
    
    init(_ addFile: MenuButton, _ addFileGroup: MenuButton) {
        firstOption = addFile
        secondOption = addFileGroup
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            firstOption
            secondOption
        }.padding(8)
    }
}
