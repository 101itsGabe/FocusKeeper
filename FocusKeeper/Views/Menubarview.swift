//
//  Menubarview.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/29/24.
//

import Foundation
import SwiftUI

struct MenuBarView: View{
    @ObservedObject var appState: AppState
    //@State var pullUpTimer: Bool = false
    //@State var startTimer: Bool = false
    
    var body: some View{
        VStack{
            Spacer()
            Toggle("Toggle Focus", isOn: $appState.isActive)
                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                .padding()
            
            if(appState.pullUpTimer){
                if (!appState.startTimer){
                    HStack{
                        Text("H:")
                        TextField("Timer(hrs)", value: $appState.timerHrs,format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 50)
                        Text("M:")
                        TextField("Timer(min)", value: $appState.timerMin,format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 50)
                        Button(action: {
                            appState.startTimer = true
                            appState.startTimerFunc()
                        }){
                            Image(systemName: "play.fill")
                                .foregroundStyle(.white)
                        }
                        .background(appState.BtnColor)
                        .cornerRadius(5)
                        .padding(3)
                        Button(action: {
                            appState.pullUpTimer = false
                            
                        }){
                            Image(systemName: "xmark.app.fill")
                                .foregroundStyle(.white)
                        }
                        .background(appState.BtnColor)
                        .cornerRadius(5)
                        .padding(.trailing)
                    }
                }
                else{
                    HStack{
                        Text("\(appState.formattedHours):\(appState.formattedMinutes): \(appState.formattedSeconds)")
                        if(!appState.timerPaused){
                            Button(action: {
                                appState.pauseTimer()
                            }){
                                Image(systemName: "pause.fill")
                            }
                            
                            Button(action: {
                                appState.pullUpTimer = false
                                appState.timerHrs = 0
                                appState.timerMin = 0
                                appState.timerSec = 0
                                appState.startTimer = false
                                appState.isActive = false
                            }){
                                Image(systemName: "xmark.app.fill")
                            }
                        }
                        else{
                            Button(action: {appState.resumeTimer()}){
                                Image(systemName: "play.fill")
                            }
                        }
                    }
                }
            }
            else{
                    
                    Button(action:{
                        
                        appState.pullUpTimer = true
                    }){
                        Image(systemName: "timer")
                            .padding(5)
                            .foregroundColor(.white)
                        Text("Start Timer")
                            .foregroundStyle(Color.white)
                    }
                    .padding(5)
                    .background(appState.BtnColor)
                    .cornerRadius(10)
                }
            Spacer()
            Text("Active Apps")
                .bold()
            List(Array(appState.focusedApps.keys), id: \.self){ key in
                HStack{
                    if let icon = appState.allApps.first(where:{ $0.name == key})?.icon{
                        Image(nsImage: icon)                    }
                    Text(key)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get:{appState.focusedApps[key] ?? false},
                        set:{appState.focusedApps[key] = $0}
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                }
            }
            .padding()
        }
    }
}
