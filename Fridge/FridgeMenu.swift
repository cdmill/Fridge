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
//                if inEditMode {
//                    MenuButton(text: "Done", action: { self.inEditMode.toggle() })
//                }
                // MARK: Edit Button
                IconButton(systemName: "ellipsis.circle", color: primaryColor, isDynamic: !inEditMode, action: { self.inEditMode = false; self.isPopover.toggle() })
                            .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                PopoverMenu(
                                    MenuButton(text: "Add File", systemName: "plus.circle.fill", action: { model.openDialog() }),
                                    MenuButton(text: "Add Group", systemName: "folder.fill.badge.plus", action: { }),
                                    MenuButton(text: "Remove File", systemName: "minus.circle.fill", action: { self.inEditMode.toggle(); self.isPopover.toggle() })
                                )}
                    
                IconButton(systemName: "gearshape", color: primaryColor, action: {} )
//                IconButton(systemName: "x.circle.fill", color: primaryColor, fontWeight: .title3, action: { NSApplication.shared.terminate(self) })
                
            }.padding([.leading, .trailing, .top])
            
            Divider().padding(.horizontal)
            
            // MARK: File Buttons
            if !model.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<model.ffiles.count, id: \.self) { i in
                        HStack {
                            if inEditMode {
                                IconButton(systemName: "minus.circle.fill", color: Color.red, isScaling: true, action: { model.removeFile(i) }).padding(.leading)
                            }
                            FileButton(text: model.ffiles[i].filename, isDynamic: !inEditMode, action: { model.openFile(i) })
                                .padding(.horizontal, inEditMode ? 0 : 8)
                                .disabled(inEditMode || isPopover)
                        }
                    }
                }
            }
            
            Divider().padding(.horizontal)
            FileButton(text: "Quit", action: { NSApplication.shared.terminate(self) }).padding(.horizontal, 8)
            
        }.padding(.bottom, 8) // bottom of VStack
    }
}
