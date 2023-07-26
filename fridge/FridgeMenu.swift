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
    @State private var inEditMode = false
    
    var body: some View {
        VStack(spacing: 5) {
            HStack{
                Text("Fridge").padding([.leading, .trailing, .top]).font(.system(.body)).foregroundColor(.white)
                Spacer()
                HStack{
                    if fridgeModel.ffiles.hasAvailableSlots {
                        ScalingButton(systemName: "plus.circle", action: {inEditMode = false; fridgeModel.openDialog()} )
                    }
                    if inEditMode {
                        ScalingButton(systemName: "minus.circle.fill", color: Color.white, isDynamic: false, action: {inEditMode.toggle()} )
                    } else {
                        ScalingButton(systemName: "minus.circle", action: {inEditMode.toggle()} )
                    }
                    ScalingButton(systemName: "x.circle", action: {inEditMode = false; NSApplication.shared.terminate(nil)} )
                }.padding([.leading, .trailing, .top])
            }
            Divider().padding([.leading, .trailing])
            
            if !fridgeModel.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<fridgeModel.ffiles.count, id: \.self) { i in
                        ZStack {
                            if inEditMode {
                                EditModeFileButton(text: fridgeModel.ffiles[i].filename, action: {} )
                            } else {
                                FileButton(text: fridgeModel.ffiles[i].filename, action: {fridgeModel.openFile(i)} )
                            }
                            HStack {
                                if inEditMode {
                                    Spacer()
                                    ScalingButton(systemName: "minus.circle",
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

// MARK: Button definitions

struct ScalingButton: View {
    let action: () -> Void
    let foreground: Color
    let isDynamic: Bool
    let systemName: String
    @State var hovering = false
    
    init(systemName: String, color foreground: Color = Color.gray, isDynamic: Bool = true, action: @escaping () -> Void) {
        self.action = action
        self.foreground = foreground
        self.isDynamic = isDynamic
        self.systemName = systemName
    }
    
    var body: some View {
        Button(action: action,
               label: { Image(systemName: systemName).foregroundColor(self.hovering && isDynamic ? Color.white : foreground) })
        .buttonStyle(.borderless)
        .onHover{ hover in hovering = hover }
        .scaleEffect(self.hovering ? 1.1 : 1.0)
    }
}

struct FileButton: View {
    let action: () -> Void
    let text: String
    @State var hovering = false
    
    init(text: String, action: @escaping () -> Void) {
        self.action = action
        self.text = text
    }
    
    var body: some View {
        Button(action: action, label: { Text(text).padding(.leading, 10).padding([.top, .bottom], 8).frame(maxWidth: .infinity, alignment: .leading) })
            .buttonStyle(.borderless)
            .onHover{ hover in hovering = hover }
            .background(self.hovering ?
                        RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.2)) :
                        RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.clear))
    }
}

struct EditModeFileButton: View {
    let action: () -> Void
    let text: String
    
    init(text: String, action: @escaping () -> Void) {
        self.action = action
        self.text = text
    }
    
    var body: some View {
        Button(action: action,
               label: { Text(text).padding(.leading, 10).padding([.top, .bottom], 8).frame(maxWidth: .infinity, alignment: .leading) })
        .buttonStyle(.borderless)
    }
}

