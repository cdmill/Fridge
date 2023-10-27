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
    
    var body: some View {
        VStack(spacing: 5) {
            // MARK: Title Bar
            HStack(spacing: 0) {
                Text("Fridge")
                    .font(.system(.body))
                    .foregroundColor(primaryColor)
                
                Spacer()
                
                IconButton(systemName: "plus", action: { model.openDialog() })
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: { NSApplication.shared.terminate(self) }, label: {Text("Quit") })
                    }))
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
