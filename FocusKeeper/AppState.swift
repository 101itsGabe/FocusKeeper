//
//  AppState.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/27/24.
//

import Foundation
import SwiftUI
import AppKit

struct FocusGroup: Hashable, Codable{
    var name: String
    var focusApps: [String]
    var isActvie: Bool
}

struct MyAppInfo: Hashable{
    var name: String
    var icon: NSImage
}

struct SessionData: Hashable, Codable{
    var startTime: Date?
    var endTime: Date?
    var openPerAppData: [String: Int]
    var inMinutes: Double? {
        guard let end = endTime, let start = startTime else {return nil}
        let duration = end.timeIntervalSince(start)
        let minutes = duration/60
        return minutes
    }
    var duration: (hours: Int, minutes: Int, seconds: Int)? {
            guard let start = startTime, let end = endTime else { return nil }
            
            let duration = end.timeIntervalSince(start)
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60
            let seconds = Int(duration) % 60
            
            return (hours, minutes, seconds)
        }
    
    var startDate: String {
        guard let start = startTime else { return "Start Time: Not available" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a" // Format for month, day, and time
        
        return formatter.string(from: start)
    }
    
    var MMDD: String{
        guard let day = startTime else {return "Start Time: Not available"}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return formatter.string(from: day)
    }
}


class AppState: NSObject, ObservableObject{
    @Published var curApp: NSRunningApplication?
    @Published var runningApps: [NSRunningApplication] = []
    @Published var focusGroups: [FocusGroup] = []
    @Published var sessionsData: [SessionData] = []
    @Published var allApps: [MyAppInfo] = []
    @Published var focusedApps: [String: Bool] = [:]
    @Published var isActive: Bool = false
    @Published var canClick: Bool = false
    
    @Published var BtnColor: Color = Color(red: 0.91, green: 0.51, blue: 0.15)
    @Published var searchBarColor: Color = Color(red: 60/255, green: 60/255, blue: 60/255)
    
    
    @Published var timerHrs: Int = 0
    @Published var timerMin: Int = 0
    @Published var timerSec: Int = 0
    @Published var timer: Timer?
    @Published var timerPaused: Bool = false
    @Published var startTimer: Bool = false
    @Published var pullUpTimer: Bool = false
    
    
    @Published var createGroupView = false
    @Published var curGroupSelected: FocusGroup?
    @Published var curSession: SessionData?
    
    private var key: String = "groupKey"
    private var sessionsKey: String = "sessionsKey"
    
    private var overlayWindow: OverlayWindow?

    
    
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
           "com.apple.dt.Xcode", // Xcode
           "com.apple.PlaygroundsMac", // Swift Playgrounds
           "com.apple.findmy", // Find My
           "com.apple.Home", // Home
           "com.apple.voice-memos", // Voice Memos
           "com.apple.weather", // Weather
           "com.apple.appstore", // App Store
           "com.apple.iBooks", // Books
           "com.apple.calculator", // Calculator
           "com.apple.dictionary", // Dictionary
           "com.apple.keynote", // Keynote
           "com.apple.numbers", // Numbers
           "com.apple.pages", // Pages
           "com.apple.SFSymbols",
           "com.apple.Terminal",          // Terminal
               "com.apple.Finder",            // Finder
               "com.apple.systempreferences", // System Preferences
               "com.apple.stocks",            // Stocks
               "com.apple.compass",           // Compass
               "com.apple.contacts",          // Contacts
               "com.apple.tips",              // Tips
               "com.apple.dashboard",         // Dashboard (if still in use)
               "com.apple.dock",              // Dock
               "com.apple.airportutility",    // AirPort Utility
               "com.apple.diskutility",       // Disk Utility
               "com.apple.ActivityMonitor",   // Activity Monitor
               "com.apple.grapher",           // Grapher
               "com.apple.stickies",          // Stickies
               "com.apple.console",           // Console
               "com.apple.keychainaccess",    // Keychain Access
               "com.apple.ScriptEditor2",     // Script Editor
               "com.apple.screenshot",        // Screenshot
               "com.apple.configurator",      // Apple Configurator
               "com.apple.remoteDesktop",     // Remote Desktop
               "com.apple.quartzcomposer",     // Quartz Composer,
               "com.apple.PreviewShell"
       ]
    
    override init(){
        super.init()
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleAppChange(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.addObserver(self,selector: #selector(handleRunningApps(_:)),name: NSWorkspace.didLaunchApplicationNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(handleRunningApps(_:)),
                                                          name: NSWorkspace.didTerminateApplicationNotification,
                                                          object: nil)
        
        updatingCurApp()
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.didActivateApplicationNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.removeObserver(self, name:
                                                                NSWorkspace.didLaunchApplicationNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.didTerminateApplicationNotification, object: nil)
                                                            
        }
    
    func getApplications(){
        runningApps = []
        let apps = NSWorkspace.shared.runningApplications
        runningApps = apps.filter { app in
            guard let bundleID = app.bundleIdentifier else { return false }
            let systemIdentifiers = ["com.apple", "com.apple.finder","com.apple.dock"]
            return importantAppIdentifiers.contains(bundleID) || !systemIdentifiers.contains { bundleID.starts(with: $0)
                || (app.localizedName?.contains("(Plugin)"))!}
        }
    }
    

    func getAllApplications() -> [MyAppInfo]{
        print("Brother")
        let fileManager = FileManager.default
        let applicationsURLs = [URL(fileURLWithPath: "/Applications"), URL(fileURLWithPath: "/System/Applications")]
        var allAppsURL: [URL] = []
        do {
            for applicationsURL in applicationsURLs {
                let directoryContents = try fileManager.contentsOfDirectory(at: applicationsURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                for item in directoryContents{
                    if item.pathExtension == "app" {
                        let appName = item.deletingPathExtension().lastPathComponent
                        if !allAppsURL.contains(where: { $0.deletingPathExtension().lastPathComponent == appName }) {
                            allAppsURL.append(item)
                        }
                    }
                }
            }
            
            for app in allAppsURL{
                let icon = NSWorkspace.shared.icon(forFile: app.path)
                let name = app.deletingPathExtension().lastPathComponent
                let newApp = MyAppInfo(name: name, icon: icon)
                allApps.append(newApp)
            }
            
            
            for app in runningApps{
                if let icon  = app.icon{
                    if let name = app.localizedName {
                        let newApp = MyAppInfo(name: name, icon: icon)
                        if(!allApps.contains(where: {$0.name == name})){
                            allApps.append(newApp)
                        }
                    }
                }
            }
             
            return allApps
            
        }
        catch{
            print(error)
        }
        return allApps
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
                    else{
                        showOverlay()
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
    
    //Overlay Functions
    
    func showOverlay(){
        
        let screens = NSScreen.screens
        
        // Create and display the overlay window
        overlayWindow = OverlayWindow(screens: screens)
        overlayWindow?.makeKeyAndOrderFront(nil)
        if(curSession != nil){
            if let appName = curApp?.localizedName{
                if let currentCount = curSession?.openPerAppData[appName] {
                    // If it exists, increment the current count
                    curSession?.openPerAppData[appName] = currentCount + 1
                } else {
                    // If it does not exist, set the count to 1
                    curSession?.openPerAppData[appName] = 1
                }
            }
        }
    }
    
        func hideOverlay(){
            overlayWindow?.closeAllPanels()
                overlayWindow = nil
        /*
        NSApplication.shared.windows.forEach { window in
            if window is OverlayWindow {
                window.orderOut(nil)

            }
        }
         */
             
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
    
    
    //Timer Functions
    func startTimerFunc(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        if(timerMin > 0){
            timerSec = 59
            timerMin = timerMin - 1
        }
        isActive = true
    }
    
    @objc func updateTime(){
        if(timerSec <= 0 && timerMin <= 0 && timerHrs <= 0){
            endTimer()
        }
        if(timerSec > 0){
            timerSec -= 1
        }
        if(timerSec == 0 && timerMin > 0){
                timerMin -= 1
                timerSec = 59
        }
        if(timerSec == 0 && timerMin == 0 && timerHrs > 0){
                timerHrs -= 1
                timerMin = 59
                timerSec = 59
            }
    }
    
    func pauseTimer(){
        timer?.fireDate = .distantFuture
        timerPaused = true
        isActive = false
    }
    
    func resumeTimer(){
        timer?.fireDate = Date()
        timerPaused = false
        isActive = true
    }
    
    func endTimer(){
        timer?.invalidate()
        timer = nil
        timerMin = 0
        timerHrs = 0
        timerSec = 0
    }
    
    var formattedHours: String {
        return String(format: "%02d", timerHrs)
    }

    var formattedMinutes: String {
        return String(format: "%02d", timerMin)
    }

    var formattedSeconds: String {
        return String(format: "%02d", timerSec)
    }
    
    
    
    
    //Focus Group JSON
    func saveGroup(group: FocusGroup){
        var groups = loadGroup() ?? []
        if let index = groups.firstIndex(where: {$0.name == group.name}){
            groups[index] = group
        }
        else{
            groups.append(group)
        }
        saveAllGroups(groups: groups)
    }
    
    func removeGroup(group: FocusGroup){
        var groups = loadGroup() ?? []
        groups.removeAll {$0.name == group.name }
        saveAllGroups(groups: groups)
        focusGroups = groups
    }
    
    func saveAllGroups(groups: [FocusGroup]){
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(groups)
            UserDefaults.standard.set(jsonData, forKey: key)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func loadGroup() -> [FocusGroup]? {
        var groups: [FocusGroup] = []
        if let jsonData = UserDefaults.standard.data(forKey: key){
            let decoder = JSONDecoder()
            do{
                groups = try decoder.decode([FocusGroup].self, from: jsonData)
                return groups
            }catch{
                print(error.localizedDescription)
            }
        }
        return groups
    }
    
    
    //Analytics JSON
    func saveAllSessions(sessions: [SessionData]){
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(sessions)
            UserDefaults.standard.set(jsonData, forKey: sessionsKey)
        }catch{
            print(error)
        }
    }
    func saveSession(session: SessionData){
        var dataSessions = loadSessions() ?? []
        dataSessions.append(session)
        saveAllSessions(sessions: dataSessions)
    }
    
    func loadSessions() -> [SessionData]? {
        var sessions: [SessionData] = []
        if let jsonData = UserDefaults.standard.data(forKey: sessionsKey){
            let decoder = JSONDecoder()
            do{
                sessions = try decoder.decode([SessionData].self, from: jsonData)
            }catch{
                print(error)
            }
        }
        return sessions
    }
    
    func startSession(){
        curSession = SessionData(startTime: Date(), endTime: nil, openPerAppData: [:])
    }
    
    func endSession(){
        curSession?.endTime = Date()
        if let sess = curSession{
            saveSession(session: sess)
        }
        curSession = nil
    }
    
}
