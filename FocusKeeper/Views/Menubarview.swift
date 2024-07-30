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
    var formattedHours: String {
        return String(format: "%02d", appState.timerHrs)
    }

    var formattedMinutes: String {
        return String(format: "%02d", appState.timerMin)
    }

    var formattedSeconds: String {
        return String(format: "%02d", appState.timerSec)
    }
    
    var body: some View{
        VStack{
            Spacer()
            Toggle("Toggle Focus", isOn: $appState.isActive)
                .toggleStyle(.switch)
                .padding()
            if(appState.timer != nil){
                HStack{
                    Text("\(formattedHours):\(formattedMinutes)")
                    if(appState.timerHrs > 0){
                        Text("Hours Left")
                    }
                    else{
                        Text("Minutes Left")
                    }
                }
            }
            Spacer()
            Text("Active Apps")
                .bold()
            List(Array(appState.focusedApps.keys), id: \.self){ key in
                HStack{
                    if let icon = appState.runningApps.first(where:{ $0.localizedName == key})?.icon{
                        Image(nsImage: icon)                    }
                    Text(key)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get:{appState.focusedApps[key] ?? false},
                        set:{appState.focusedApps[key] = $0}
                    ))
                    .toggleStyle(.switch)
                }
            }
            .padding()
        }
        .onChange(of: appState.isActive){
            if(appState.isActive == false){
                appState.endTimer()
            }
        }
    }
}
