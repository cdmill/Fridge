//
//  fridge.swift
//  fridge
//
//  Created by Casey Miller on 2023-07-18.
//

import Foundation
import SwiftUI

class StackWindow: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            if #available(macOS 11.0, *) {
                button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
            } else {
            }
        }
        setup()
    }
    
    func setup() {
        let menu = NSMenu()
        
        let one =  NSMenuItem(title: "Add File to Stack", action: #selector(addFileToStack), keyEquivalent: "a")
        menu.addItem(one)
        statusItem.menu = menu
    }
    
    @objc func addFileToStack() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a File to Add to Stack"
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [.pdf]
        dialog.canDownloadUbiquitousContents = true
        dialog.canResolveUbiquitousConflicts = false
        
        var fileChoice: URL?
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            fileChoice = dialog.url
        }
        else {
            // Cancel was pressed
            return
        }
        if fileChoice == nil {
            // There has been a problem
            return
        }
        //... use fileChoice
    }
}
