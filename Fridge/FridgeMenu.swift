//
//  FridgeMenu.swift
//  fridge
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
                    .padding([.leading, .trailing, .top])
                    .font(.system(.body).bold())
                    .foregroundColor(primaryColor)
                Spacer()
                HStack{
                    // MARK: Add File Button
                    if model.ffiles.hasAvailableSlots {
                        IconButton(systemName: "plus.circle", color: primaryColor, isDynamic: !isPopover, action: { inEditMode = false; self.isPopover.toggle() })
                        .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                PopoverMenu(
                                    MenuButton(text: "Add File", action: { model.openDialog() }),
                                    MenuButton(text: "Add Group", action: { })
                            )}
                    }
                    // MARK: Edit/Remove File Button
                    IconButton(systemName: "minus.circle", color: primaryColor, isDynamic: !inEditMode, action: { inEditMode.toggle() } )
                    
                    // MARK: Quit Button
                    IconButton(systemName: "x.circle", color: primaryColor, action: { NSApplication.shared.terminate(self) })
                }.padding([.leading, .trailing, .top])
            }
            
            Divider().padding([.leading, .trailing])
            
            // MARK: File Buttons
            if !model.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<model.ffiles.count, id: \.self) { i in
                        HStack {
                            if inEditMode {
                                IconButton(systemName: "minus.circle", color: Color.red, action: { model.removeFile(i) }).padding(.leading)
                            }
                            FileButton(text: model.ffiles[i].filename, isDynamic: !inEditMode, action: { model.openFile(i) })
                                .padding([.leading, .trailing], inEditMode ? 0 : 8)
                                .disabled(inEditMode || isPopover)
                        }
                    }
                }
            }
            
        }.padding(.bottom, 8) // bottom of VStack
    }
}
