//
//  FridgeMenu.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation
import SwiftUI

struct FridgeMenu: View {
    @StateObject private var fridgeModel = Fridge()
    @State private var menu = ["File", "File Group"]
    @State private var inEditMode = false
    @State private var isPopover = false
    
    var body: some View {
        VStack(spacing: 5) {
            HStack{
                Text("Fridge")
                    .padding([.leading, .trailing, .top])
                    .font(.system(.body))
                    .foregroundColor(.white)
                Spacer()
                HStack{
                    if fridgeModel.ffiles.hasAvailableSlots {
                        IconButton(systemName: "plus.circle", action: { inEditMode = false; self.isPopover.toggle() })
                            .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                PopoverMenu(
                                    MenuButton(text: "Add File", action: {fridgeModel.openDialog()}),
                                    MenuButton(text: "Add File Group", action: {})
                            )}
                    }
                    if inEditMode {
                        IconButton(systemName: "minus.circle.fill", isDynamic: false, action: {inEditMode.toggle()} )
                    } else {
                        IconButton(systemName: "minus.circle", action: {inEditMode.toggle()} )
                    }
                    IconButton(systemName: "x.circle", action: {inEditMode = false; NSApplication.shared.terminate(nil)} )
                }.padding([.leading, .trailing, .top])
            }
            Divider().padding([.leading, .trailing])
            
            if !fridgeModel.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<fridgeModel.ffiles.count, id: \.self) { i in
                        ZStack {
                            if inEditMode || isPopover {
                                FileButton(text: fridgeModel.ffiles[i].filename, isDynamic: false, action: {})
                            } else {
                                FileButton(text: fridgeModel.ffiles[i].filename, action: {fridgeModel.openFile(i)} )
                            }
                            HStack {
                                if inEditMode {
                                    Spacer()
                                    IconButton(systemName: "minus.circle",
                                               color: Color.red,
                                               isDynamic: false,
                                               action: {fridgeModel.removeFile(i)} ).padding(.trailing)
                                }
                            }
                        }.padding([.leading, .trailing], 8)
                    }
                }
            }
            
        }.padding(.bottom, 8)
    }
}

// MARK: Buttons and Popover Menu

struct IconButton: View {
    let action: () -> Void
    let foreground: Color
    let isDynamic: Bool
    let systemName: String
    @State var hovering = false
    
    init(systemName: String, color foreground: Color = Color.white, isDynamic: Bool = true, action: @escaping () -> Void) {
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

struct FileButton: View {
    let action: () -> Void
    let isDynamic: Bool
    let text: String
    @State var hovering = false
    
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
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering && isDynamic ? 1.015 : 1.0)
        .background(self.hovering && isDynamic ?
                    RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.2)) :
                    RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.clear))
    }
}

struct MenuButton: View {
    let action: () -> Void
    let text: String
    @State var hovering = false
    
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
                .foregroundStyle(self.hovering ? .white : .gray)
        })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
    }
}

struct PopoverMenu: View {
    @State private var firstOption: MenuButton
    @State private var secondOption: MenuButton
    
    init(_ addFile: MenuButton, _ addFileGroup: MenuButton) {
        self.firstOption = addFile
        self.secondOption = addFileGroup
    }
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            firstOption
            secondOption
        }.padding(8)
    }
}
