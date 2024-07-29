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
    
    var body: some View{
        VStack{
            Spacer()
            Toggle("Toggle Focus", isOn: $appState.isActive)
                .toggleStyle(.switch)
                .padding()
            Spacer()
            Text("Active Apps")
                .bold()
            List(Array(appState.focusedApps.keys), id: \.self){ key in
                HStack{
                    if let icon = appState.runningApps.first(where:{ $0.localizedName == key})?.icon{
                        Image(nsImage: icon)
                            .padding()
                    }
                    Text(key)
                        .padding()
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
    }
}
