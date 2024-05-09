//
//  MemberDetailView.swift
//  Library Management System
//
//  Created by user2 on 08/05/24.
//

import SwiftUI
import Charts



struct MemberDetailView: View {
    @ObservedObject var userAuthViewModel: AuthViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    @EnvironmentObject var themeManager: ThemeManager
//    @State var memberData: [(month: String, count: Int)] = [
//            (month: "June", count: 10),
//            (month: "July", count: 20),
//            (month: "August", count: 30),
//            (month: "September", count: 50),
//            (month: "October", count: 20),
//            (month: "November", count: 100),
//            (month: "December", count: 30),
//            (month: "January", count: 90),
//            (month: "February", count: 0),
//            (month: "March", count: 0),
//            (month: "April", count: 0),
//            (month: "May", count: 9)
//    ]
    
    @State var monthlyMembersCount: [membersCount] = []
    @State var selectedBar: Int = -1
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray4))
                .frame(width: 100,height: 5)
                .padding(.bottom)
          VStack() {
                GroupBox ("Member Frequency") {
                    if !monthlyMembersCount.isEmpty {
                        Chart {
                            ForEach(monthlyMembersCount.indices, id: \.self) { index in
                                let abbrMonth = getAbbrMonthName(monthlyMembersCount[index].month)
                                BarMark(
                                    x: .value("month", abbrMonth),
                                    y: .value("Count", monthlyMembersCount[index].count)
                                )
                                .foregroundStyle(Color(themeManager.selectedTheme.primaryThemeColor))
                                .accessibilityLabel("\(monthlyMembersCount)")
                                
                            }
                        }
                    }
                }
                            }
            .frame(height: 280)
            .padding(.bottom)
            
            VStack{
                    ZStack(alignment:.leading){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("requestCard"))
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                            .frame(height: 125)
                        HStack{
                            VStack(alignment: .leading){
                                Text("Approved")
                                    .font(.title3)
                                    .foregroundStyle(Color.gray)
                                Text(String("\(userAuthViewModel.approvedUsers)"))
                                    .font(.title)
                                    .bold()
                                    .padding(.top)
                            }
                            .padding(.horizontal)
                            
                            Divider()
                                .frame(height: 100)
                            
                            VStack(alignment: .leading){
                                Text("Applied")
                                    .font(.title3)
                                    .foregroundStyle(Color.gray)
                                Text(String("\(userAuthViewModel.appliedUsers)"))
                                    .font(.title)
                                    .bold()
                                    .padding(.top)
                            }
                            .padding(.horizontal)
                            
                            Divider()
                                .frame(height: 100)
                            
                            VStack(alignment: .leading){
                                Text("Rejected")
                                    .font(.title3)
                                
                                    .foregroundStyle(Color.gray)
                                Text(String("\(userAuthViewModel.rejectedUsers)"))
                                    .font(.title)
                                    .bold()
                                    .padding(.top)
                            }
                            .padding(.horizontal)
                        }
                    }
                
            }
            Spacer()
        }
        .padding()
        .onAppear {
            monthlyMembersCount = configViewModel.currentConfig[0].monthlyMembersCount
        }

    }
    func getAbbrMonthName(_ fullMonthName: String) -> String {
            let monthAbbr = [
                "January": "Jan",
                "February": "Feb",
                "March": "Mar",
                "April": "Apr",
                "May": "May",
                "June": "Jun",
                "July": "Jul",
                "August": "Aug",
                "September": "Sep",
                "October": "Oct",
                "November": "Nov",
                "December": "Dec"
            ]
            return monthAbbr[fullMonthName] ?? fullMonthName
        }
}

struct MemberDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var themeManager = ThemeManager()
        @StateObject var staffViewMod = StaffViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var userAuthViewModel = AuthViewModel()
        @StateObject var configViewModel = ConfigViewModel()
        return MemberDetailView(userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
            .environmentObject(themeManager)
    }
}
