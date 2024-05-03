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
                Section(header: Text("Staff Details").font(.callout)) {
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
                                .foregroundColor(themeManager.selectedTheme.secondaryThemeColor)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section(header: Text("Contact Information").font(.callout)) {
                    HStack{
                        Text("Email:")
                            .font(.callout)
                        Text(staffMember.email)
                            .font(.callout)
                    }
                    HStack{
                        Text("Mobile:")
                            .font(.callout)
                        Text(staffMember.mobile)
                            .font(.callout)
                    }
                    HStack{
                        Text("Aadhar:")
                            .font(.callout)
                        Text(staffMember.aadhar)
                            .font(.callout)
                    }
                }
                
                Section(header: Text("Dates").font(.callout)) {
                    HStack {
                        Text("Created On:")
                            .font(.callout)
                        Text("\(formattedDate(from: staffMember.createdOn))")
                            .font(.callout)
                    }
                    HStack{
                        Text("Updated On:")
                            .font(.callout)
                        Text("\(formattedDate(from: staffMember.updatedOn))")
                            .font(.callout)
                    }
                    
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
 
    }
}

func formattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" // Customize the date format here
    return dateFormatter.string(from: date)
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
