//
//  AppState.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/27/24.
//

import Foundation
import SwiftUI
import AppKit


class AppState: NSObject, ObservableObject{
    @Published var curApp: NSRunningApplication?
    @Published var runningApps: [NSRunningApplication] = []
    @Published var focusedApps: [String: Bool] = [:]
    @Published var isActive: Bool = false
    @Published var canClick: Bool = false
    @Published var focusGroups: [String] = []
    @Published var timerHrs: Int = 0
    @Published var timerMin: Int = 0
    
    let importantAppIdentifiers = [
           "com.apple.Safari",  // Safari
           "com.apple.mail",    // Mail
           "com.apple.iCal",    // Calendar
           "com.apple.AddressBook", // Contacts
           "com.apple.iChat",   // Messages
           "com.apple.FaceTime", // FaceTime
           "com.apple.Notes",   // Notes
           "com.apple.reminders", // Reminders
           "com.apple.Maps",    // Maps
           "com.apple.Music",   // Music
           "com.apple.TV",      // TV
           "com.apple.podcasts", // Podcasts
           "com.apple.news",    // News
           "com.apple.Photos",  // Photos
           "com.apple.Preview", // Preview
           "com.apple.TextEdit", // TextEdit
           "com.apple.dt.Xcode" // Xcode
       ]
    
    override init(){
        super.init()
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleAppChange(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleRunningApps), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        updatingCurApp()
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.didActivateApplicationNotification, object: nil)
        }
    
    func getApplications(){
        runningApps = []
        let apps = NSWorkspace.shared.runningApplications
        runningApps = apps.filter { app in
            guard let bundleID = app.bundleIdentifier else { return false }
            let systemIdentifiers = ["com.apple", "com.apple.finder","com.apple.dock"]
            return importantAppIdentifiers.contains(bundleID) || !systemIdentifiers.contains { bundleID.starts(with: $0) }
        }
    }
    
    
    @objc dynamic private func handleAppChange(_ notification: NSNotification){
        updatingCurApp()
        if(isActive == false){
            hideOverlay()
        }
        else{
            if let appName = curApp?.localizedName{
                if(focusedApps.keys.contains(appName) || appName == "FocusKeeper"){
                    if(appName == "FocusKeeper" || focusedApps[appName] == true){
                        hideOverlay()
                    }
                }
                else{
                    showOverlay()
                }
            }
        }
    }
    
    @objc func handleRunningApps(_ notification: NSNotification){
        getApplications()
    }
    
    
    func updatingCurApp(){
        if let activeApp = NSWorkspace.shared.frontmostApplication {
            //print(NSWorkspace.shared.frontmostApplication?.localizedName ?? "bleh")
            self.curApp = activeApp
        }
        else{
            print("this would be interesting?")
        }
    }
    
    func showOverlay(){
        let overlay = OverlayWindow()
        overlay.makeKeyAndOrderFront(nil)
    }
    
    func hideOverlay(){
        NSApplication.shared.windows.forEach { window in
            if window is OverlayWindow {
                window.orderOut(nil)
            }
        }
    }
    
    func checkOverLay(){
        if (isActive){
            if let appName = curApp?.localizedName{
                if(focusedApps.keys.contains(appName) || appName == "FocusKeeper"){
                    if(appName == "FocusKeeper" || focusedApps[appName] == true){
                        hideOverlay()
                    }
                }
                else{
                    showOverlay()
                }
            }
        }
        else{
            hideOverlay()
        }
    }
}
