//
//  RevenueDetailView.swift
//  Library Management System
//
//  Created by user2 on 08/05/24.
//

import SwiftUI
import Charts

struct RevenueDetailView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var configViewModel: ConfigViewModel
    @State var monthlyIncome: [monthlyIncome] = []
    
    //    @State var monthlyRevenue: [(month: String, revenue: Int)] = [
    //               (month: "June", revenue: 10),
    //               (month: "July", revenue: 20),
    //               (month: "August", revenue: 30),
    //               (month: "September", revenue: 50),
    //               (month: "October", revenue: 20),
    //               (month: "November", revenue: 100),
    //               (month: "December", revenue: 30),
    //               (month: "January", revenue: 90),
    //               (month: "February", revenue: 0),
    //               (month: "March", revenue: 0),
    //               (month: "April", revenue: 0),
    //               (month: "May", revenue: 9)
    //       ]
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray4))
                    .frame(width: 100,height: 5)
                    .padding()
                Spacer()
                GroupBox ("Monthly Revenue") {
                    if !monthlyIncome.isEmpty {
                        Chart {
                            ForEach(monthlyIncome.indices, id: \.self) { index in
                                let abbrMonth = getAbbrMonthName(monthlyIncome[index].month)
                                LineMark(
                                    x: .value("month", abbrMonth),
                                    y: .value("Count", monthlyIncome[index].income)
                                )
                                .foregroundStyle(Color(themeManager.selectedTheme.primaryThemeColor))
                                .accessibilityLabel("\(monthlyIncome)")
                            }
                        }
                        
                    }
                }
                .padding()
                .frame(height: 300)
                VStack (alignment: .leading){
                    Text("Details:")
                        .font(.title)
                    .padding()
                    HStack{
                        Text("Month")
                        Spacer()
                        Text("Revenue")
                    }
                    
                    .padding(.horizontal)
                    VStack{
                        ForEach(0..<monthlyIncome.count, id: \.self){ i in
                            Divider()
                            HStack {
                                Text(monthlyIncome[i].month)
                                Spacer()
                                Text("$\(monthlyIncome[i].income)")
                            }
                            .padding(.horizontal)
                            
                        }
                        
                        .listStyle(.plain)
                    }
                    .padding()
                }
                Spacer()
            }
            .onAppear {
                monthlyIncome = configViewModel.currentConfig[0].monthlyIncome
        }
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

struct RevenueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var staffViewMod = StaffViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var userAuthViewModel = AuthViewModel()
        @StateObject var configViewModel = ConfigViewModel()
        return RevenueDetailView( configViewModel: configViewModel)
            .environmentObject(themeManager)
    }
}
