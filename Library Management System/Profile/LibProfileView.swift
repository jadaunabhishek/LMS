//
//  LibProfileView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 09/05/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LibProfileView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    @ObservedObject var staffViewModel: StaffViewModel
    
    var body: some View {
        VStack {
            List {
                Section() {
                    VStack(alignment: .center){
                        
                        if let profileURL = URL(string: staffViewModel.staff[0].profileImageURL){
                            AsyncImage(url: profileURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .padding(.top, 20)
                                default:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Rectangle())
                                        .cornerRadius(10)
                                }
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        }
                        
                        Text(staffViewModel.staff[0].name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Section(header: Text("Contact Information").font(.callout)) {
                    HStack{
                        Text("Email:")
                            .font(.callout)
                        Text(staffViewModel.staff[0].email)
                            .font(.callout)
                    }
                    HStack{
                        Text("Mobile:")
                            .font(.callout)
                        Text(staffViewModel.staff[0].mobile)
                            .font(.callout)
                    }
                }
                
                Section(header: Text("Dates").font(.callout)) {
                    HStack {
                        Text("Created On:")
                            .font(.callout)
                        Text("\(formattedDate(from: staffViewModel.staff[0].createdOn))")
                            .font(.callout)
                    }
                    HStack{
                        Text("Updated On:")
                            .font(.callout)
                        Text("\(formattedDate(from: staffViewModel.staff[0].updatedOn))")
                            .font(.callout)
                    }
                    
                }
                
                Section{
                    Button {
                        UserDefaults.standard.set("LogOut", forKey: "emailLoggedIn")
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                                .foregroundColor(Color.red)
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct LibProfileView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var configViewModel = ConfigViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var staffViewModel = StaffViewModel()
        let themeManager = ThemeManager()
        return LibProfileView(LibViewModel: LibViewModel, configViewModel: configViewModel, staffViewModel: staffViewModel).environmentObject(themeManager)
    }
}
