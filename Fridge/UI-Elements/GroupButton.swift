//
//  GroupButton.swift
//  Fridge
//
//  Created by Casey Miller on 2023-08-24.
//

import Foundation
import SwiftUI


struct GroupButton <Content: View>: View, Themeable {
    
    @State private var hovering = false
    @State private var isExpanded = false
    @ViewBuilder let expandableView : Content
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            
            Button(action: {
                withAnimation() {
                    self.isExpanded.toggle()
                }}, label: {
                    Text("Group Name")
                        .padding(.leading, 18)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(self.hovering ? primaryColor : buttonTextHoverColor)
                })
            .buttonStyle(.borderless)
            .onHover{ hover in hovering = hover }
            
            if self.isExpanded {
                self.expandableView
            }
        }
    }
}
