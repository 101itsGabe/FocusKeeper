//
//  AnalyticsPage.swift
//  FocusKeeper
//
//  Created by Gabriel Mannheimer on 8/8/24.
//

import SwiftUI
import Charts


func calcDay(){
    
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter.string(from: date)
}

func formatMonth(_ date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter.string(from: date)
}

func formatYear(_ date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY"
    return formatter.string(from: date)
}


struct AnalyticsPage: View {
    @StateObject var appState: AppState
    @State var curSession: SessionData? = nil
    @State var curDate: String = ""
    @State var index: Int = 0
    @State var dateHover: Bool = false
    @State var chooseDate: Bool = false
    @State var dayChart: Bool = true
    @State var selectedDay: Date? = nil
    @State var isDatePicker: Bool = false
    
    var dates: [Date] {
        let calendar = Calendar.current
        if let today = selectedDay{
            return (-2...2).compactMap {
                calendar.date(byAdding: .day, value: $0, to: today)
            }        }
        return []
    }
    
    var body: some View {
        VStack{
            HStack{
                
                Button(action:{dayChart = true}){
                    Text("Per Day")
                        .font(.system(size: 16))
                        .underline(dayChart)
                        .foregroundStyle(dayChart ? appState.BtnColor : Color.white)
                        .padding(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action:{dayChart = false}){
                    Text("Per Session")
                        .font(.system(size: 16))
                        .underline(!dayChart)
                        .foregroundStyle(!dayChart ? appState.BtnColor : Color.white)
                        .padding(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if(dayChart){
                VStack {
                    HStack(alignment: .center){
                        if let date = selectedDay{
                            Text(formatMonth(date))
                                .bold()
                                .padding()
                            Text(formatYear(date))
                                .bold()
                                .padding()
                        }
                    }
                    HStack(spacing: 50){
                        HStack{
                            if(isDatePicker == false){
                                Button(action:{isDatePicker = true}){
                                    Image(systemName: "calendar")
                                        .background(Color.clear)
                                }
                                .background(Color.clear)
                                .scaleEffect(1.3)
                            }
                            else{
                                DatePicker("", selection: Binding(
                                    get: { selectedDay ?? Date() },    // Provide a default value if `selectedDay` is `nil`
                                    set: {
                                        selectedDay = $0
                                    }
                                ))
                                .datePickerStyle(.field)
                                .labelsHidden()
                            }
                        }
                        .frame(width: 120)
                        .padding(.leading)
                        
                        
                        
                        HStack(alignment: .center, spacing: 20) { // Adjust spacing as needed
                            ForEach(dates, id: \.self) { date in
                                if let curDay = selectedDay {
                                    Text(formatDate(date))
                                        .padding()
                                        .font(.system(size: 18))
                                        .background(
                                            
                                            Circle()
                                                .strokeBorder(appState.BtnColor, lineWidth: 2)
                                                .opacity(Calendar.current.isDate(date, inSameDayAs: curDay) ? 1 : 0)
                                        )
                                        .onTapGesture {
                                            selectedDay = date
                                        }

                                        
                                }
                            }
                        }
                        Spacer()
                            .frame(width: 120)
                    }
                }
                .onAppear(){
                    selectedDay = Date()
                }
                .onChange(of: selectedDay){
                    isDatePicker = false
                }
                
                if let curDay = selectedDay{
                    if(!appState.sessionsData.contains(where: {
                        return Calendar.current.isDate($0.startTime!, inSameDayAs: curDay)
                    })){
                        VStack{
                            Spacer()
                            Text("No Sessions Today 🧑‍💻")
                                .padding()
                                .bold()
                                .font(.system(size: 16))
                            Spacer()
                        }.frame(height: .infinity)
                    }
                    else{
                        HStack{
                            Spacer()
                            Text("By Min")
                                .bold()
                                .padding()
                        }
                        Chart{
                            ForEach(appState.sessionsData, id:\.self){session in
                                if(Calendar.current.isDate(session.startTime!,inSameDayAs: curDay)){
                                    LineMark(x: .value("Time (in Hrs)", session.startTime!), y: .value("Duration", session.inMinutes!))
                                }
                            }
                        }
                        .padding()
                    }
            }
            }
            else{
                
                HStack{
                    Button(action:{
                        if(index - 1 > 0){
                            index -= 1
                            curSession = appState.sessionsData[index]
                            curDate = curSession?.startDate ?? ""
                        }
                    }){
                        Image(systemName: "chevron.backward")
                    }
                    if(chooseDate){
                        Picker("Select A Session", selection: $curDate){
                            ForEach(appState.sessionsData, id: \.self){ session in
                                Text(session.startDate).tag(session.startDate)
                            }
                        }
                        .frame(width: 200)
                        .onChange(of: curDate) { newValue in
                            curDate = newValue
                            curSession = appState.sessionsData.first(where: {$0.startDate == newValue})
                            index = appState.sessionsData.firstIndex(where: {$0.startDate == newValue}) ?? 0
                            chooseDate.toggle()
                        }
                    }else{
                        Text("\(curDate)")
                            .padding()
                            .underline(dateHover)
                            .background(dateHover ? Color.gray.opacity(0.2) : Color.clear)
                            .cornerRadius(5)
                            .font(.system(size: 14))
                            .onHover(){hovering in
                                if(hovering){
                                    dateHover = true
                                    NSCursor.pointingHand.push()
                                }else{
                                    dateHover = false
                                    NSCursor.pop()
                                }
                            }
                            .onTapGesture(){
                                chooseDate.toggle()
                            }
                    }
                    Button(action:{
                        if(index + 1 < appState.sessionsData.count){
                            index += 1
                            curSession = appState.sessionsData[index]
                            curDate = curSession?.startDate ?? ""
                        }
                    }){
                        Image(systemName: "chevron.forward")
                    }
                }
                .onAppear(){
                    if let session = appState.sessionsData.last(where:{$0.startTime != nil}){
                        print(session.startDate)
                        curSession = session
                        curDate = session.startDate
                        if let curIndex = appState.sessionsData.lastIndex(where: {$0.startTime != nil}){
                            index = curIndex
                        }
                    }
                    else{
                        print("uh")
                    }
                }
                if let duration = curSession?.duration{
                    Text("Duration: \(duration.hours) hours, \(duration.minutes) minutes, \(duration.seconds) seconds")
                        .padding()
                        .font(.system(size: 14))
                }
                
                Text("How many times you folded 😔")
                if let appData = curSession?.openPerAppData{
                    if(appData.count <= 0){
                        VStack{
                            Spacer()
                            Text("You didnt open anything 👏")
                                .bold()
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .frame(height: .infinity)
                    }
                    else{
                        Chart{
                            ForEach(Array(appData.keys), id:\.self){app in
                                BarMark(x: .value("App", app), y: .value("Usage", appData[app] ?? 0))
                                    .foregroundStyle(appState.BtnColor)
                                
                            }
                            
                        }
                        .padding()
                    }
                }
            }

        }
    }
}

#Preview {
    AnalyticsPage(appState: AppState())
}
