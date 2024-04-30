//
//  StaffViewModel.swift
//  Library Management System
//
//  Created by Manvi Singhal on 25/04/24.
//

import SwiftUI

struct StaffDetailsView: View {
    let staffMember: Staff
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var staffViewModel = StaffViewModel()
    
    var body: some View {
        NavigationView{
            List {
                Section(header: Text("Staff Details")) {
                    VStack(alignment: .center){
                        if let profileURL = URL(string: staffMember.profileImageURL) {
                            AsyncImage(url: profileURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.top, 20)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                            }
                            Text(staffMember.name)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section(header: Text("Contact Information")) {
                    Text(staffMember.email)
                        .font(.subheadline)
                    Text(staffMember.mobile)
                        .font(.subheadline)
                    Text(staffMember.aadhar)
                        .font(.subheadline)
                }
                
                Section(header: Text("Dates")) {
                    Text("Created On: \(staffMember.createdOn)")
                        .font(.subheadline)
                    Text("Updated On: \(staffMember.updatedOn)")
                        .font(.subheadline)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarItems(
            leading: Spacer(),
            trailing:
                NavigationLink(
                    destination: EditStaffDetailsView(staffMember: staffMember),
                    label: {
                        Text("Edit")
                            .font(.title3)
                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                    }
                )
        )
        .onAppear(
            perform: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
                    Task{
                        staffViewModel.getStaff()
                    }
                }
            }
        )
//        .onAppear{
//            staffViewModel.getStaff()
//        }
    }
}

struct StaffDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'ZZZ"
        let createdOnDate = dateFormatter.date(from: "April 24, 2024") ?? Date()
        let updatedOnDate = dateFormatter.date(from: "April 24, 2024") ?? Date()
        let sampleStaff = Staff(
            userID: "VzCFTZhEjoMZpFuzBw1Kt1S1AGm1",
            name: "Manvi Singhal",
            email: "Manvi.Singhal",
            mobile: "librarian",
            profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/library-management-syste-6cc1e.appspot.com/o/staffProfileImages%2F35PmRqJThks5zqXgn02g.jpeg?alt=media&token=6334f513-e00e-4d77-83fe-e9be3dae9c5a",
            aadhar: "6976927239",
            role: "librarian",
            password: "gyhg",
            createdOn: createdOnDate,
            updatedOn: updatedOnDate
        )
        
        return StaffDetailsView(staffMember: sampleStaff)
            .environmentObject(themeManager)
    }
}
