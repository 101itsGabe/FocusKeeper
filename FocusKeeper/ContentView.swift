//
//  ContentView.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/24/24.
//

import SwiftUI
import AppKit

struct ContentView: View {
    
    @StateObject var appState : AppState
    
    var body: some View {
        if(appState.createGroupView){
            CreateGroupView(appState: appState, setGroup: appState.curGroupSelected)
        }
        else{
            MainView(appState: appState)
        }
    }
}

#Preview {
    ContentView(appState: AppState())
}
