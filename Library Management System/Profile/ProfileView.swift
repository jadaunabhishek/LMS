//
//  ProfileView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 09/05/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    
    var body: some View {
        VStack {
            List {
                Section() {
                    VStack(alignment: .center){
                        
                        if let profileURL = URL(string: LibViewModel.currentMember[0].profileImage){
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
                        
                        Text(LibViewModel.currentMember[0].name)
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
                        Text(LibViewModel.currentMember[0].email)
                            .font(.callout)
                    }
                    HStack{
                        Text("Mobile:")
                            .font(.callout)
                        Text(LibViewModel.currentMember[0].mobile)
                            .font(.callout)
                    }
                }
                
                Section(header: Text("Dates").font(.callout)) {
                    HStack {
                        Text("Created On:")
                            .font(.callout)
                        Text("\(formattedDate(from: LibViewModel.currentMember[0].createdOn))")
                            .font(.callout)
                    }
                    HStack{
                        Text("Updated On:")
                            .font(.callout)
                        Text("\(formattedDate(from: LibViewModel.currentMember[0].updateOn))")
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
//        .navigationBarItems(
//            trailing:
//                NavigationLink(
//                    destination: ProfileCompletedView(LibViewModel: LibViewModel, configViewModel: configViewModel),
//                    label: {
//                        Text("Edit")
//                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
//                    }
//                )
//        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var configViewModel = ConfigViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        let themeManager = ThemeManager()
        return ProfileView(LibViewModel: LibViewModel, configViewModel: configViewModel).environmentObject(themeManager)
    }
}
