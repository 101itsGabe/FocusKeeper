//
//  OverlayWindow.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/28/24.
//

import Foundation
import AppKit

class OverlayWindow: NSPanel{
    
    private var panels: [NSPanel] = []
    
    override var canBecomeKey: Bool {
            return true
        }
    override var canBecomeMain: Bool {
            return true
        }

    init(screens: [NSScreen]) {
            super.init(contentRect: .zero, styleMask: [], backing: .buffered, defer: false)
            
            // Create a panel for each screen
            for screen in screens {
                let screenFrame = screen.frame
                
                let panel = NSPanel(
                    contentRect: screenFrame,
                    styleMask: [.borderless, .nonactivatingPanel],
                    backing: .buffered,
                    defer: false
                )
                
                panel.isOpaque = false
                panel.backgroundColor = NSColor.black.withAlphaComponent(0.5) // Semi-transparent black
                panel.level = .floating
                panel.ignoresMouseEvents = false
                panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .stationary]
                
                let blurView = NSVisualEffectView(frame: panel.contentView!.bounds)
                blurView.autoresizingMask = [.width, .height]
                blurView.blendingMode = .withinWindow
                blurView.material = .fullScreenUI
                blurView.state = .active
                
                panel.contentView?.addSubview(blurView)
                
                let textField = NSTextField()
                textField.stringValue = "Go Back!"
                textField.font = NSFont.systemFont(ofSize: 36) // Customize font size
                textField.textColor = NSColor.white // Customize text color
                textField.backgroundColor = .clear
                textField.isBordered = false
                textField.isEditable = false
                textField.sizeToFit() // Adjust size to fit the text
                
                // Center the text field in the window
                textField.frame.origin = CGPoint(x: (panel.contentView!.bounds.width - textField.frame.width) / 2,
                                                 y: (panel.contentView!.bounds.height - textField.frame.height) / 2)
                
                // Add the text field on top of the blur view
                blurView.addSubview(textField)
                
                panel.makeKeyAndOrderFront(nil)
                panel.orderFrontRegardless()
                
                panels.append(panel) // Keep a reference to the panel
            }
        }
        
        // Example function to close all panels if needed
        func closeAllPanels() {
            for panel in panels {
                panel.close()
            }
        }
    
    // Override makeKeyAndOrderFront to ensure it's shown as intended
    override func makeKeyAndOrderFront(_ sender: Any?) {
        super.makeKeyAndOrderFront(sender)
        // Additional configuration can be done here if needed
    }
}
