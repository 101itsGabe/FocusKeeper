//
//  FocusKeeperApp.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/24/24.
//

import SwiftUI

@main
struct FocusKeeperApp: App {
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @StateObject var appState = AppState()
    @State var curList: [String] = []
    
    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .environment(\.colorScheme, .dark)
        }
        MenuBarExtra(
                    "App Menu Bar Extra", systemImage: "target")
                {
                    MenuBarView(appState: appState)
                }
                .menuBarExtraStyle(WindowMenuBarExtraStyle())
    }
    
    
}

struct Wrapper: View{
    @State var realList: [NSRunningApplication]
    @Binding var curList: [String: Bool]
    
    var body: some View{
        List(Array(curList.keys), id: \.self){ key in
            HStack{
                Text(key)
            }
        }
        .onChange(of: curList){
        }
            
    }

        
}

