//
//  OverlayWindow.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/28/24.
//

import Foundation
import AppKit

class OverlayWindow: NSPanel{
    
    override var canBecomeKey: Bool {
            return true
        }
    override var canBecomeMain: Bool {
            return true
        }

    
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer: Bool) {
        let screenFrame = NSScreen.main?.frame ?? .zero
        let windowFrame = NSRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)
        
        super.init(contentRect: windowFrame, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false)
        self.isOpaque = false
        self.backgroundColor = .black
        self.backgroundColor = NSColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.level = .floating
        self.ignoresMouseEvents = false
        self.collectionBehavior = [.canJoinAllSpaces,.fullScreenAuxiliary, .transient, .stationary]
        
        
        let blurView = NSVisualEffectView(frame: self.contentView!.frame)
        blurView.autoresizingMask = [.width, .height]
        blurView.blendingMode = .withinWindow
        blurView.material = .fullScreenUI
        blurView.state = .active
        
        self.contentView?.addSubview(blurView)
        
        let textField = NSTextField()
        let textField2 = NSTextField()
                
                textField.stringValue = "Go Back!"
                textField.font = NSFont.systemFont(ofSize: 36) // Customize font size
                textField.textColor = NSColor.white // Customize text color
                textField.backgroundColor = .clear
                textField.isBordered = false
                textField.isEditable = false
                textField.sizeToFit() // Adjust size to fit the text
                
                // Center the text field in the window
                textField.frame.origin = CGPoint(x: (self.contentView!.bounds.width - textField.frame.width) / 2,
                                                 y: (self.contentView!.bounds.height - textField.frame.height) / 2)
                
                // Add the text field on top of the blur view
                blurView.addSubview(textField)
        
        self.makeKeyAndOrderFront(nil)
        self.orderFrontRegardless()
        
    }
    
    // Override makeKeyAndOrderFront to ensure it's shown as intended
    override func makeKeyAndOrderFront(_ sender: Any?) {
        super.makeKeyAndOrderFront(sender)
        // Additional configuration can be done here if needed
    }
}
