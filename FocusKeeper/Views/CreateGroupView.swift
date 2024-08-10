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
                let curFocusGroup = FocusGroup.init(name: groupName, focusApps: curGroup, isActvie: false)
                appState.focusGroups.append(curFocusGroup)
                appState.saveGroup(group: curFocusGroup)
                appState.createGroupView = false
            }){
                Image(systemName: "folder.badge.plus")
                    .padding(3)
                Text("Create Group")
            }
            VStack(spacing: 5){
                Spacer(minLength: 3)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    TextField("Search", text: $searchApp)
                        .font(.system(size: 14))
                    
                }
                .padding(5)
                .textFieldStyle(.roundedBorder)
                .background(Color(white: 0.3))
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
                        allApps = appState.getAllApplications()
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
