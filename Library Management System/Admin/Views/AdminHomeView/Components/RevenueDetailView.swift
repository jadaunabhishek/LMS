//
//  RevenueDetailView.swift
//  Library Management System
//
//  Created by user2 on 08/05/24.
//

import SwiftUI
import Charts

struct RevenueDetailView: View {
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
                        .foregroundStyle(Color(.blue))
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

#Preview {
    RevenueDetailView()
}
