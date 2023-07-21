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
    @State var isHover = false
    
    var body: some View {
        HStack{
            Text("FRIDGE").padding().font(.system(.title3).weight(.semibold)).foregroundColor(.white)
            Spacer()
            HStack{
                Button{fridgeModel.openDialog()} label: {Image(systemName: "plus.circle")}.buttonStyle(.borderless)
                
                Button{ NSApplication.shared.terminate(nil) } label: {Image(systemName: "x.circle.fill")}.buttonStyle(.borderless)
            }.padding()
        }
        
        VStack {
            ForEach(0..<fridgeModel.ffiles.count, id: \.self) { i in
                if !fridgeModel.ffiles.isEmpty {
                    HStack {
                        Button{fridgeModel.openFile(i)} label: {Text(fridgeModel.ffiles[i].filename)}.buttonStyle(.borderless)
                        Spacer()
                        Button{fridgeModel.removeFile(i)} label: {Image(systemName: "minus.circle")}.buttonStyle(.borderless)
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    FridgeMenu()
}
