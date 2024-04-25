//
//  Membership.swift
//  Library Management System
//
//  Created by admin on 22/04/24.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var shouldNavigate = false
    @Published var shouldNavigateToAdmin = false
    @Published var shouldNavigateToLibrarian = false
    @Published var shouldNavigateToMember = false
    @Published var shouldNavigateToGeneral = false
    private var db = Firestore.firestore()

    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle the login error
                print("Error logging in: \(error.localizedDescription)")
            } else {
                // Login was successful, check for user role
                print("Login successful!")
                UserDefaults.standard.set(true, forKey: "emailLoggedIn")
                
                // Assume the UID is used as the document ID in `users` collection
                self?.fetchUserRole(email: email)
            }
        }
    }

    private func fetchUserRole(email: String) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { [weak self] (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching user by email: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let document = querySnapshot?.documents.first else {
                        print("No documents found or role not found")
                        return
                    }

                    let role = document.data()["role"] as? String ?? ""
                    // Check role and navigate based on it
                    DispatchQueue.main.async {
                        // Implement role-based navigation logic
                        self?.navigateBasedOnRole(role: role)
                    }
                }
    }

    private func navigateBasedOnRole(role: String){
        // Implement your role-based navigation here
        // For example:
        print(role)
        DispatchQueue.main.async {
                switch role {
                case "admin":
                    self.shouldNavigateToAdmin = true
                case "librarian":
                    self.shouldNavigateToLibrarian = true
                case "member":
                    self.shouldNavigateToMember = true
                default:
                    self.shouldNavigateToGeneral = true
                }
            }
    }
}
