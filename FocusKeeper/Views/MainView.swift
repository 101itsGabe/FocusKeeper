//
//  MainView.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/29/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    @StateObject var appState : AppState
    @State var startTimer: Bool = false
    
    var body: some View {
        VStack {
        
            HStack{
                if let icon = self.appState.curApp?.icon{
                    Image(nsImage: icon)
                }
                Text(self.appState.curApp?.localizedName ?? "")
            }
            Toggle("Activate Focus", isOn: $appState.isActive)
                .toggleStyle(.switch)
                .padding()
            if(startTimer){
                HStack{
                    Text("Hours")
                    TextField("Timer(hrs)", value: $appState.timerHrs,format: .number)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .frame(width: 100)
                    Text("Min")
                    TextField("Timer(min)", value: $appState.timerMin,format: .number)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .frame(width: 100)
                    Spacer()
                    Button(action: {}){
                        Image(systemName: "play")
                    }
                }
            }
            else{
                Button(action:{
                    startTimer = true
                }){
                    Text("Start Timer")
                }
            }
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
    }
}

#Preview {
    MainView(appState: AppState())
}

