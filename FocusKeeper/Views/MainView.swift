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
    @State var pullUpTimer: Bool = false
    
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
            if(pullUpTimer){
                if (!startTimer){
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
                        Button(action: {
                            startTimer = true
                            appState.startTimer()
                        }){
                            Image(systemName: "play")
                        }
                    }
                }
                else{
                    Text("\(appState.timerHrs):\(appState.timerMin): \(appState.timerSec)")
                }
            }
            else{
                Button(action:{
                    pullUpTimer = true
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
            .onChange(of: appState.timer){
                if(appState.timer == nil){
                    pullUpTimer = false
                }
            }
        }
        .padding()
    }
}

#Preview {
    MainView(appState: AppState())
}

