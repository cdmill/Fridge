//
//  PopoverMenu.swift
//  Fridge
//
//  Created by Casey Miller on 2023-08-01.
//

import Foundation
import SwiftUI

struct PopoverMenu: View {
    var menuItems: [MenuButton] = []
    
    init(_ item: MenuButton...) {
        self.menuItems.append(contentsOf: item)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(0..<menuItems.count, id: \.self) { i in
                menuItems[i]
            }
        }.padding(8)
    }
}
