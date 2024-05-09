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
    
    @State var monthlyRevenue: [(month: String, revenue: Int)] = [
               (month: "June", revenue: 10),
               (month: "July", revenue: 20),
               (month: "August", revenue: 30),
               (month: "September", revenue: 50),
               (month: "October", revenue: 20),
               (month: "November", revenue: 100),
               (month: "December", revenue: 30),
               (month: "January", revenue: 90),
               (month: "February", revenue: 0),
               (month: "March", revenue: 0),
               (month: "April", revenue: 0),
               (month: "May", revenue: 9)
       ]
    var body: some View {
        GroupBox ("Monthly Revenue") {
            if !monthlyRevenue.isEmpty {
                Chart {
                    ForEach(monthlyRevenue.indices, id: \.self) { index in
                        LineMark(
                            x: .value("month", monthlyRevenue[index].month),
                            y: .value("Count", monthlyRevenue[index].revenue)
                        )
                        .foregroundStyle(Color(themeManager.selectedTheme.primaryThemeColor))
                        .accessibilityLabel("\(monthlyRevenue)")
                        //                                            .accessibilityValue("\(weight.pounds) pounds")
                    }
                }
            }
        }
        .padding()
        .frame(height: 300)
    }
}

struct RevenueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var staffViewMod = StaffViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var userAuthViewModel = AuthViewModel()
        @StateObject var configViewModel = ConfigViewModel()
        return RevenueDetailView()
            .environmentObject(themeManager)
    }
}
