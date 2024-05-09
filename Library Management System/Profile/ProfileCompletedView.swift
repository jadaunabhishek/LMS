//
//  ProfileCompletedView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 09/05/24.
//

import SwiftUI
import FirebaseDatabaseInternal
import FirebaseAuth
import Firebase
import FirebaseStorage

struct ProfileCompletedView: View {
    
    @State private var isEditing: Bool = false
    @State private var userProfile = LibrarianViewModel()
    var profileImageURL: URL?
    @State private var errorMessage: String?
    @State private var profileImage: Image?
    
    var body: some View {
        VStack{
            Text("User Profile")
            VStack {
                Button {
                    UserDefaults.standard.set("LogOut", forKey: "emailLoggedIn")
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                      print("Error signing out: %@", signOutError)
                    }
                    
                } label: {
                    Text("Log out")
                        .foregroundColor(Color.red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    ProfileCompletedView()
}

