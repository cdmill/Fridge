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
    
    @StateObject private var fridgeModel = Fridge()
    @State private var inEditMode = false
    @State private var isPopover = false
    
    var body: some View {
        VStack(spacing: 5) {
            // MARK: Title Bar
            HStack{
                Text("Fridge")
                    .padding([.leading, .trailing, .top])
                    .font(.system(.body))
                    .foregroundColor(primaryColor)
                Spacer()
                HStack{
                    // MARK: Add File Button
                    if fridgeModel.ffiles.hasAvailableSlots {
                        IconButton(systemName: "plus.circle", color: primaryColor, isDynamic: !isPopover, action: { inEditMode = false; self.isPopover.toggle() })
                        .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                PopoverMenu(
                                    MenuButton(text: "Add File", action: { fridgeModel.openDialog() }),
                                    MenuButton(text: "Add File Group", action: { })
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
            if !fridgeModel.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<fridgeModel.ffiles.count, id: \.self) { i in
                        ZStack {
                            let filename = fridgeModel.ffiles[i].filename
                            if inEditMode || isPopover {
                                FileButton(text: filename, isDynamic: false, action: {} )
                            } else {
                                FileButton(text: filename, action: { fridgeModel.openFile(i) })
                            }
                            HStack {
                                if inEditMode {
                                    Spacer()
                                    IconButton(systemName: "minus.circle", color: Color.red, isDynamic: false, action: { fridgeModel.removeFile(i) }).padding(.trailing)
                                }
                            }
                        }.padding([.leading, .trailing], 8)
                    }
                }
            }
            
        }.padding(.bottom, 8) // bottom of VStack
    }
}
