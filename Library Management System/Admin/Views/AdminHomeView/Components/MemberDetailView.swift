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
    
    @State var montlyMembersCount: [membersCount] = []
    @State var selectedBar: Int = -1
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray4))
                .frame(width: 100,height: 5)
                .padding()
            let maxCount = montlyMembersCount.map { $0.count }.max() ?? 0
//            HStack{
//                VStack{
//                    Spacer()
//                    HStack(spacing:6){
//                        VStack(spacing:0){
//                            ForEach(0..<maxCount/10){ index in
//                                Text("\(maxCount - (index * 10))")
//                                    .font(.caption2)
//                                Rectangle()
//                                    .frame(width: 0, height: 40)
//                                
//                            }
//                            Text("0")
//                                .font(.caption2)
//                            
//                        }
//                        .offset(y:10)
//                        Rectangle()
//                            .fill(Color.black)
//                            .frame(width: 1, height: CGFloat(maxCount)*5)
//                        
//                        
//                    }
//                }
//                .padding(.bottom)
//                ScrollView(.horizontal) {
//                    HStack(spacing: 10) {
//                        if !montlyMembersCount.isEmpty {
//                            
//                            ForEach(montlyMembersCount.indices, id: \.self) { index in
//                                VStack {
//                                    Spacer()
//                                    Rectangle()
//                                        .fill(Color.blue)
//                                        .frame(width: 40, height: CGFloat(montlyMembersCount[index].count * 5))
//                                    Text("\(montlyMembersCount[index].month)")
//                                }
//                                .onTapGesture {
//                                    selectedBar = index
//                                }
//                            }
//                        }
//                    }
//                    .padding(.top, 20)
//                }
//                .scrollIndicators(.hidden)
//                
//                
//            }
            VStack() {
                GroupBox ("Member Frequency") {
                    if !montlyMembersCount.isEmpty {
                        Chart {
                            ForEach(montlyMembersCount.indices, id: \.self) { index in
                                BarMark(
                                    x: .value("month", montlyMembersCount[index].month),
                                    y: .value("Count", montlyMembersCount[index].count)
                                )
                                .foregroundStyle(Color(.blue))
                                .accessibilityLabel("\(montlyMembersCount)")
                                //                                            .accessibilityValue("\(weight.pounds) pounds")
                            }
                        }
                    }
                }
                            }
            .frame(height: 280)
            .padding(.bottom)
//            .groupBoxStyle(YellowGroupBoxStyle())
//            .frame(width: ViewConstants.chartWidth,  height: ViewConstants.chartHeight)
//
//            Text("Generate Data")
//                .font(.title2)
//            HStack {
//                Button("10") {
//                    weightVm.generateWeightData(numberOfDays: 10)
//                }
//                Button("50") {
//                    weightVm.generateWeightData(numberOfDays: 50)
//                }
//                Button("100") {
//                    weightVm.generateWeightData(numberOfDays: 100)
//                }
//                Button("1000") {
//                    weightVm.generateWeightData(numberOfDays: 1000)
//                }
//            }
//
//            ScrollView(.horizontal){
//                Chart{
//                    ForEach(memberData.indices, id: \.self) { index in
//                        BarMark(
//                            x: .value("Month", memberData[index].month),
//                            y: .value("Members", memberData[index].count)
//                        )
//                    }
//                }
//            }
//            Text(configViewModel.currentConfig[0].monthlyMembersCount)
            VStack{
//                if selectedBar == -1 {
//                    Text("Total")
//                } else {
//                    Text("\(selectedBar)")
//                }
//
                // MARK: Applied and Rejected
                HStack(spacing:12){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray4).opacity(0.5))
                            .frame(height: 125)
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
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray4).opacity(0.5))
                            .frame(height: 125)
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
                    }
                }
                
                // MARK: Approved and New
                HStack(spacing:12){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray4).opacity(0.5))
                            .frame(height: 125)
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
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray4).opacity(0.5))
                            .frame(height: 125)
                        VStack(alignment: .leading){
                                Text("New")
                                    .font(.title3)
                            .foregroundStyle(Color.gray)
                            Text(String("\(userAuthViewModel.newUsers)"))
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
        .task {
            montlyMembersCount = configViewModel.currentConfig[0].monthlyMembersCount
        }

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
