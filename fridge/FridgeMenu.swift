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
    @State private var addFileButtonHovered = false
    @State private var editButtonHovered = false
    @State private var quitButtonHovered = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text("Fridge").padding().font(.system(.body)).foregroundColor(.white)
                Spacer()
                HStack{
                    if fridgeModel.ffiles.count < 4 {
                        Button{inEditMode = false; fridgeModel.openDialog()} label: {Image(systemName: "plus.circle")}.buttonStyle(.borderless)
                            .onHover{ hover in self.addFileButtonHovered = hover }
                            .scaleEffect(self.addFileButtonHovered ? 1.1 : 1.0)
                    }
                    Button{inEditMode.toggle()} label: {inEditMode ? Image(systemName: "minus.circle.fill") : Image(systemName: "minus.circle")}.buttonStyle(.borderless)
                        .onHover{ hover in editButtonHovered = hover }
                        .scaleEffect(self.editButtonHovered ? 1.1 : 1.0)
                    Button{inEditMode = false; NSApplication.shared.terminate(nil) } label: {Image(systemName: "x.circle")}.buttonStyle(.borderless)
                        .onHover{ hover in quitButtonHovered = hover }
                        .scaleEffect(self.quitButtonHovered ? 1.1 : 1.0)
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
                                    else { self.hovered = -1 }}
                                .background(self.hovered == i && !inEditMode ? RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.2)) : RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.clear))
                        }
                        HStack {
                            if inEditMode {
                                Spacer()
                                Button{fridgeModel.removeFile(i)} label: {Image(systemName: "minus.circle").foregroundColor(Color.red)}.buttonStyle(.borderless)
                                    .onHover{ hover in
                                        if hover && inEditMode { self.hovered = i}
                                        else { self.hovered = -1 }}
                                    .scaleEffect(self.hovered == i && inEditMode ? 1.1 : 1.0)
                            }
                        }
                    }.padding()
                }
            }.padding([.top, .bottom], -15)
        }.padding(.bottom)
    }
}

//struct PrimitiveScaleButton: PrimitiveButtonStyle {
//    
//    func makeBody(configuration: Self.Configuration) -> some View {
//        ScaleButton(configuration: configuration, scaleAmount: 1.1)
//    }
//}
//
//private extension PrimitiveScaleButton {
//    struct ScaleButton: View {
//        
//        private enum State {
//            case hovering
//            case outOfBounds
//            
//            var isHovering: Bool {
//                switch self {
//                case .hovering:
//                    return true
//                default:
//                    return false
//                }
//            }
//        }
//        
//        @State private var isPressed = false
//        
//        let configuration: PrimitiveScaleButton.Configuration
//        let scaleAmount: CGFloat
//        
//        var body: some View {
//            .onHover(hover in
//                     if hover {
//                State = .hovering
//            })
//        }
//        
//        
//        
//    }
//}
