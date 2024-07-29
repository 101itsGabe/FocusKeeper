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
        MainView(appState: appState)
        /*
        VStack {
        
            HStack{
                if let icon = self.appState.curApp?.icon{
                    Image(nsImage: icon)
                }
                Text(self.appState.curApp?.localizedName ?? "")
            }
            Toggle("Activate Focus", isOn: $appState.isActive)
                .toggleStyle(.switch)
            List(appState.runningApps, id: \.bundleIdentifier){ app in
                HStack{
                    if let icon = app.icon{
                        Image(nsImage: icon)
                    }
                    Text(app.localizedName ?? "Unknown")
                    Spacer()
                    Toggle("",isOn: Binding(get: {
                        appState.focusedApps[app.localizedName ?? ""] ?? false
                    }, set: { newValue in
                        appState.focusedApps[app.localizedName ?? ""] = newValue
                        print(appState.focusedApps)
                    }))
                    .toggleStyle(.switch)
                     
                }
            }
            .padding()
            .onAppear(){
                appState.getApplications()
                appState.updatingCurApp()
            }
            .onChange(of: appState.isActive){ newVal in
                appState.isActive = newVal
                appState.checkOverLay()
            }
        }
        .padding()
         */
    }
}

#Preview {
    ContentView(appState: AppState())
}
