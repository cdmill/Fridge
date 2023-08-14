//
//  FridgeMenu.swift
//  Fridge
//
//  Created by Casey Miller on 2023-07-20.
//

import Foundation
import SwiftUI

struct FridgeWindow: View, Themeable {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject private var model = FridgeModel()
    @State private var expandTitleBarButtons = false
    @State private var isPopover = false
    
    var body: some View {
        VStack(spacing: 5) {
            // MARK: Title Bar
            HStack{
                Text("Fridge")
                    .font(.system(.body))
                    .foregroundColor(primaryColor)
                
                Spacer()
                
                if expandTitleBarButtons {
                    IconButton(systemName: "doc.fill", action: { model.openDialog() })
                    IconButton(systemName: "folder.fill", action: {})
                    IconButton(systemName: "gear", action: {} ).contextMenu(ContextMenu(menuItems: {
                        Button(action: { NSApplication.shared.terminate(self) }, label: { Text("Quit") })
                    }))
                }
                IconButton(systemName: "ellipsis.circle", isDynamic: !expandTitleBarButtons, action: { expandTitleBarButtons.toggle() })
                
            }.padding([.horizontal, .top])
            
            Divider().padding(.horizontal)
            
            // MARK: File Buttons
            if !model.ffiles.isEmpty {
                VStack(spacing: 5) {
                    ForEach(0..<model.ffiles.count, id: \.self) { i in
                        HStack {
                            FileButton(text: model.ffiles[i].filename, action: { model.openFile(i) })
                                .padding(.horizontal, 8)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action: { model.removeFile(i) }, label: {Text("Remove file") })
                                }))
                        }
                    }
                }
            }
            
        }.padding(.bottom, 8) // bottom of VStack
    }
}
