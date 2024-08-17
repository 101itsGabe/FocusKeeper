//
//  CreateGroupView.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 7/30/24.
//

import Foundation
import SwiftUI


struct CreateGroupView: View{
    @StateObject var appState: AppState
    @State var groupName: String = ""
    @State var curGroup: [String] = []
    @State var allApps: [MyAppInfo] = []
    @State var searchApp: String = ""
    @State var setGroup: FocusGroup?
    
    var body: some View{
        VStack{
            HStack{
                Button(action:{appState.createGroupView = false}){
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .font(.title2) // Adjust font size
                        .padding(5)
                }

                Spacer()
            }
            .background(Color.clear)
            TextField("Group Name", text: $groupName)
                .padding(5)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(10)
                .frame(maxWidth: 400)
                .font(.system(size: 14))
            Button(action: {
                if(setGroup == nil){
                    setGroup = FocusGroup.init(name: groupName, focusApps: curGroup, isActvie: false)
                    
                }
                else{
                    setGroup?.name = groupName
                    setGroup?.focusApps = curGroup
                }
                if let curSetGroup = setGroup{
                    print(curSetGroup.focusApps)
                    if let index = appState.focusGroups.firstIndex(where: { $0.name == curSetGroup.name }) {
                        appState.focusGroups[index] = curSetGroup
                    }
                    else{
                        appState.focusGroups.append(curSetGroup)
                    }
                    appState.saveGroup(group: curSetGroup)
                    appState.createGroupView = false
                }
            }){
                Image(systemName: "folder.badge.plus")
                    .padding(3)
                if(setGroup == nil){
                    Text("Create Group")
                }
                else{
                    Text("Save Group")
                }
            }
            VStack(spacing: 5){
                Spacer(minLength: 3)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    TextField("Search App", text: $searchApp)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 14))
                    
                }
                .padding(5)
                .textFieldStyle(.roundedBorder)
                .background(appState.searchBarColor)
                .cornerRadius(10)
                .frame(maxWidth: 400)
                
                List(appState.allApps, id: \.self){ app in
                    if(app.name.lowercased().contains(searchApp.lowercased()) || searchApp == ""){
                        HStack{
                            Image(nsImage: app.icon)
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text(app.name)
                            Spacer()
                            Toggle("", isOn: Binding(get:{
                                curGroup.contains(app.name)
                            }, set:{newValue in
                                if(newValue){
                                    curGroup.append(app.name)
                                }else{
                                    curGroup.removeAll{$0 == app.name}
                                    print(curGroup)
                                }
                            }))
                            
                        }
                        .padding(8)
                        .background(
                            curGroup.contains(app.name) ?
                            Color.white.opacity(0.2) : Color.clear
                        )
                        .cornerRadius(10) // Rounded corners
                        .shadow(radius: 5) // Optional: add shadow for better visual effect
                    }
                }
                .padding()
                .onAppear(){
                    if(allApps.count <= 0 ){
                        //let HELP = appState.getAllApplications()
                        allApps = appState.allApps
                    }
                    if let paramGroup = setGroup{
                        groupName = paramGroup.name
                        curGroup = []
                        for app in paramGroup.focusApps {
                            curGroup.append(app)
                        }
                    }
                }
                .cornerRadius(10)
                .listSectionSeparator(.hidden)
            }
            .padding()
        
        }
    }
}

#Preview {
   CreateGroupView(appState: AppState())
}
