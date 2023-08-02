//
//  FridgeMenu.swift
//  Fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation
import SwiftUI

struct FridgeMenu: View, Themeable {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject private var model = Fridge()
    @State private var inEditMode = false
    @State private var isPopover = false
    
    var body: some View {
        VStack(spacing: 5) {
            // MARK: Title Bar
            HStack{
                Text("Fridge")
                    .font(.system(.body).bold())
                    .foregroundColor(primaryColor)
                Spacer()
                if inEditMode {
                // MARK: Add File Button
                    if model.ffiles.hasAvailableSlots {
                        IconButton(systemName: "plus", color: primaryColor, isDynamic: !isPopover, fontWeight: .title3, action: { self.isPopover.toggle() })
                            .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                PopoverMenu(
                                    MenuButton(text: "Add File", action: { model.openDialog() }),
                                    MenuButton(text: "Add Group", action: { })
                                )}
                    }
                }
                // MARK: Edit Button
                IconButton(systemName: "slider.horizontal.3", color: primaryColor, isDynamic: !inEditMode, fontWeight: .title3, action: { inEditMode.toggle() } )
                
            }.padding([.leading, .trailing, .top])
            
            Divider().padding(.horizontal)
            
            // MARK: File Buttons
            if !model.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<model.ffiles.count, id: \.self) { i in
                        HStack {
                            if inEditMode {
                                IconButton(systemName: "minus.circle", color: Color.red, action: { model.removeFile(i) }).padding(.leading)
                            }
                            FileButton(text: model.ffiles[i].filename, isDynamic: !inEditMode, action: { model.openFile(i) })
                                .padding(.horizontal, inEditMode ? 0 : 8)
                                .disabled(inEditMode || isPopover)
                        }
                    }
                }
            }
            
        }.padding(.bottom, 8) // bottom of VStack
    }
}
