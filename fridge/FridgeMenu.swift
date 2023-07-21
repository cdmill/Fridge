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
    @State private var hovered = -1
    @State private var inEditMode = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text("Fridge").padding().font(.system(.callout).weight(.semibold)).foregroundColor(.white)
                Spacer()
                HStack{
                    Button{fridgeModel.openDialog()} label: {Image(systemName: "plus.circle")}.buttonStyle(.borderless)
                    Button{inEditMode.toggle()} label: {inEditMode ? Image(systemName: "minus.circle.fill") : Image(systemName: "minus.circle")}.buttonStyle(.borderless)
                    Button{ NSApplication.shared.terminate(nil) } label: {Image(systemName: "x.circle")}.buttonStyle(.borderless)
                }.padding()
            }
            Divider().padding().padding(.bottom, -15).padding(.top, -20)
            ForEach(0..<fridgeModel.ffiles.count, id: \.self) { i in
                if !fridgeModel.ffiles.isEmpty {
                    ZStack {
                        HStack {
                            Button{if !inEditMode {fridgeModel.openFile(i)}} label: {Text(fridgeModel.ffiles[i].filename).padding(8).frame(maxWidth: .infinity, alignment: .leading)}
                                .buttonStyle(.borderless)
                                .onHover{ hover in
                                    if hover && !inEditMode { self.hovered = i}
                                    else { self.hovered = -1}}
                                .background(self.hovered == i ? RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.2)) : RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.clear))
                        }
                        HStack {
                            if inEditMode {
                                Spacer()
                                Button{fridgeModel.removeFile(i)} label: {Image(systemName: "minus.circle").foregroundColor(Color.red)}.buttonStyle(.borderless)
                            }
                        }
                    }.padding()
                }
            }.padding([.top, .bottom], -15)
        }.padding(.bottom)
    }
}

