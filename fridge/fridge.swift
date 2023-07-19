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
                let icon = NSImage(systemSymbolName: "refrigerator.fill", accessibilityDescription: "fridge")
                var config = NSImage.SymbolConfiguration(pointSize: 13, weight: .black)
                button.image = icon?.withSymbolConfiguration(config)
            }
            else {
                // previous macOS versions not supported
            }
        }
        setup()
    }
    
    func setup() {
        let menu = NSMenu()
        
        let addFileOption =  NSMenuItem(title: "Add File", action: #selector(addFileToStack), keyEquivalent: "a")
        menu.addItem(addFileOption)
        statusItem.menu = menu
    }
    
    @objc func addFileToStack() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a File to Add"
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
