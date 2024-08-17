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
    //@State var startTimer: Bool = false
    //@State var pullUpTimer: Bool = false
    @State var tabsInt: Int = 1
    @State var showApps = [String: Bool]()
    @State var hoverIndex: String? = nil
    
    @State var isHoverGroups: Bool = false
    @State var isTextGroups: Bool = false
    @State var isTextApps: Bool = false
    @State var isHoverApps: Bool = false
    @State var isTextAnalytics: Bool = false
    @State var isHoverAnalytics: Bool = false
    @State var isGroupSelected: Bool = false

    @State var searchApp: String = ""

    
    var body: some View {
        VStack {
            
            HStack{
                if let icon = self.appState.curApp?.icon{
                    Image(nsImage: icon)
                        .padding(.leading)
                        .padding(5)
                }
                Text(self.appState.curApp?.localizedName ?? "")
                    .padding(.trailing)
            }
            .background(Color.white.opacity(0.2))
            .cornerRadius(50)
            .padding(5)
            HStack{
                Toggle("Toggle Focus", isOn: $appState.isActive)
                    .toggleStyle(SwitchToggleStyle(tint: appState.BtnColor))
                    .padding()
                
                if let curGroup = appState.curGroupSelected?.name{
                    Text("Group: \(curGroup)")
                }
            }
            
            //Timer and Group Stack
            if(appState.pullUpTimer){
                if (!appState.startTimer && appState.timer == nil){
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
                            appState.startTimer = true
                            appState.startTimerFunc()
                        }){
                            Image(systemName: "play.fill")
                                .foregroundStyle(.white)
                        }
                        .background(appState.BtnColor)
                        .cornerRadius(5)
                        Button(action: {
                            appState.pullUpTimer = false
                            
                        }){
                            Image(systemName: "xmark.app.fill")
                                .foregroundStyle(.white)
                        }
                        .background(appState.BtnColor)
                        .cornerRadius(5)
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
                            .backgroundStyle(appState.BtnColor)
                            
                            
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
                HStack{
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
                    
                    Button(action: {
                        appState.createGroupView = true
                        appState.curGroupSelected = nil
                    }){
                        Image(systemName:
                                "square.grid.3x1.folder.fill.badge.plus")
                        .foregroundColor(.white)
                        .padding(5)
                        Text("Create Group")
                            .foregroundStyle(Color.white)
                    }
                    .padding(5)
                    .background(appState.BtnColor)
                    .cornerRadius(10)
                    
                }
                
            }
            
            //Tabs Stack
            HStack{
                Button(action: {
                    tabsInt = 1
                    isTextApps = true
                    isTextGroups = false
                    isTextAnalytics = false
                }){
                    Text("Running Apps")
                        .font(.system(size: 16))
                        .underline(isTextApps)
                        .foregroundStyle(isTextApps ? appState.BtnColor : Color.white)
                        .padding(10)
                        .onHover(perform: { hovering in
                            if(hovering){
                                isHoverApps = true
                                NSCursor.pointingHand.push()
                            }else{
                                isHoverApps = false
                                NSCursor.pop()
                                }
                        })
                }
                .buttonStyle(PlainButtonStyle())
                .background(isHoverApps ? Color.white.opacity(0.2) : Color.clear)
                .cornerRadius(5)
                Button(action: {
                    tabsInt = 2
                    isTextGroups = true
                    isTextApps = false
                    isTextAnalytics = false
                }){
                    Text("Focus Groups")
                        .font(.system(size: 16))
                        .underline(isTextGroups)
                        .foregroundStyle(isTextGroups ? appState.BtnColor : Color.white)
                        .padding(10)
                        .onHover(perform: { hovering in
                            if(hovering){
                                isHoverGroups = true
                                NSCursor.pointingHand.push()
                            }else{
                                isHoverGroups = false
                                NSCursor.pop()
                            }
                        })
                }
                .buttonStyle(PlainButtonStyle())
                .background(isHoverGroups ? Color.white.opacity(0.2) : Color.clear)
                .cornerRadius(5)
                
                Button(action:{
                    tabsInt = 3
                    isTextAnalytics = true
                    isTextApps = false
                    isTextGroups = false
                }){
                    Text("Analystics")
                        .font(.system(size: 16))
                        .underline(isTextAnalytics)
                        .foregroundStyle(isTextAnalytics ? appState.BtnColor : Color.white)
                        .padding(10)
                        .onHover(perform: { hovering in
                            if(hovering){
                                isHoverAnalytics = true
                                NSCursor.pointingHand.push()
                            }else{
                                isHoverAnalytics = false
                                //NSCursor.pop()
                            }
                        })
                }
                .buttonStyle(PlainButtonStyle())
                .background(isHoverAnalytics ? Color.white.opacity(0.2) : Color.clear)
                .cornerRadius(5)
            }
            .padding()
            
            //Running Apps List == 1
            if(tabsInt == 1){
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    TextField("Search App", text: $searchApp)
                        .textFieldStyle(PlainTextFieldStyle()) // Use a plain style to remove the border
                                .background(Color.clear)
                                .font(.system(size: 14))
                }
                .padding(5)
                .background(appState.searchBarColor)
                .cornerRadius(10)
                .frame(width: 400)
                List(appState.runningApps, id: \.bundleIdentifier){ app in
                    if(app.localizedName!.lowercased().contains(searchApp.lowercased()) || searchApp == ""){
                        HStack{
                            if let icon = app.icon{
                                Image(nsImage: icon)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            Text(app.localizedName ?? "Unknown")
                            Spacer()
                            Toggle("",isOn: Binding(get: {
                                appState.focusedApps[app.localizedName ?? ""] ?? false
                            }, set: { newValue in
                                appState.focusedApps[app.localizedName ?? ""] = newValue
                            }))
                            .toggleStyle(SwitchToggleStyle(tint: appState.BtnColor))
                            
                        }
                        .padding()
                    }
                }
                .padding()
                .onAppear(){
                    appState.getApplications()
                    appState.updatingCurApp()
                    //appState.getAllApplications()
                }
                .onChange(of: appState.isActive){ newVal in
                    appState.isActive = newVal
                    appState.checkOverLay()
                }
                .onChange(of: appState.timer){
                    if(appState.timer == nil){
                        appState.pullUpTimer = false
                    }
                }
                
            }
            
            //Focus Groups List == 2
            else if(tabsInt == 2){
                if(appState.focusGroups.count > 0){
                    Text("Click A Group")}
                else{
                    Text("Create A Group")
                }
                List(appState.focusGroups, id: \.self){ group in
                    VStack {
                        HStack {
                            Button(action: {
                                showApps[group.name, default: false].toggle()
                            }){
                                if(showApps[group.name] == true){
                                    Image(systemName: "chevron.down")
                                }
                                else{
                                    Image(systemName: "chevron.right")
                                }
                            }
                            
                            Text(group.name)
                                .padding()
                                .onTapGesture {
                                    showApps[group.name, default: false].toggle()
                                }
                                .cornerRadius(10)
                                .font(.system(size: 16))
                            
                            Spacer()
                            Button(action: { appState.removeGroup(group: group) }) {
                                Image(systemName: "trash.fill")
                            }
                            .padding()
                            
                        }
                        .onHover { isHovering in
                            if isHovering {
                                hoverIndex = group.name
                                NSCursor.pointingHand.push()
                                
                            } else {
                                hoverIndex = nil
                                NSCursor.pop()
                            }
                        }
                        .padding()
                        .background(hoverIndex == group.name ? Color.white.opacity(0.2) : Color.clear)
                        .cornerRadius(50)
                        if(showApps[group.name] == true){
                            VStack{
                                HStack{
                                    Button(action:{
                                        appState.createGroupView = true
                                        appState.curGroupSelected = group
                                    }){
                                        Image(systemName: "pencil")
                                    }
                                    .padding()
                                    Spacer()
                                }
                                ForEach(group.focusApps, id: \.self){ app in
                                    HStack(alignment: .center, spacing: 4){
                                        HStack{
                                            if let icon = appState.allApps.first(where: {$0.name == app})?.icon{
                                                HStack{
                                                    Image(nsImage: icon)
                                                        .resizable()
                                                        .frame(width: 40, height: 40)
                                                    
                                                }
                                            }
                                            else{
                                                
                                                Text("No Image")
                                            }
                                            Spacer()
                                            HStack{
                                                Text(app)
                                                    .padding(.trailing)
                                                Spacer()
                                            }
                                            
                                            
                                        }
                                    }
                                    .frame(width: 200)
                                    
                                }
                                .padding()
                            }
                            .background(Color.gray.opacity(0.1)) // Light gray background for the VStack
                            .border(appState.BtnColor, width: 2) // Blue border around the VStack
                            .cornerRadius(5) // Rounded corners for the VStack
                        }
                    }
                    .onTapGesture{
                        appState.curGroupSelected = group
                    }
                }
                .padding()
                .onAppear(){
                    appState.focusGroups = appState.loadGroup() ?? []
                    for group in appState.focusGroups{
                        showApps[group.name] = false
                    }
                    //var temp = appState.getAllApplications()
                }
                .onChange(of: appState.curGroupSelected){
                    //print(appState.curGroupSelected)
                    for app in appState.focusedApps{
                        appState.focusedApps[app.key] = false
                    }
                    appState.focusedApps.removeAll()
                    if let apps = appState.curGroupSelected?.focusApps{
                        var focusedApps: [String: Bool] = [:]
                        for app in apps{
                            let val: (String, Bool ) = (app, true)
                            focusedApps[app] = true
                        }
                        
                        appState.focusedApps = focusedApps
                    }
                }
            }
            
            
            //Analytics List Tab == 3
            else if(tabsInt == 3){
                if(appState.sessionsData.count <= 0){
                    Text("Go Do that hockey!")
                        .padding()
                }else{
                    AnalyticsPage(appState: appState)
                }
            }
            
        }
        //End of Full Screen VStack
        .onAppear(){
            tabsInt = 1
            isTextApps = true
            appState.getApplications()
            appState.updatingCurApp()
            appState.sessionsData = appState.loadSessions() ?? []
            appState.allApps = appState.getAllApplications()
            //print(appState.sessionsData)
        }
        .onChange(of: appState.isActive){
            if(appState.isActive == true){
                appState.startSession()
            }else{
                appState.endSession()
                appState.sessionsData = appState.loadSessions() ?? []
            }
        }
        .onChange(of: appState.focusedApps){
            if(appState.curGroupSelected != nil && isGroupSelected == true){
                appState.curGroupSelected = nil
                isGroupSelected = false
            }
            else if (appState.curGroupSelected != nil && isGroupSelected == false){
                isGroupSelected = true
            }
        }
    }
}

#Preview {
    MainView(appState: AppState())
}

