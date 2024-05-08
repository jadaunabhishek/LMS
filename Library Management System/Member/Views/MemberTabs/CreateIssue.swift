//
//  CreateIssue.swift
//  Library Management System
//
//  Created by Admin on 06/05/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct CreateIssue: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var message: String = ""
    @State private var subject: String = ""
    @State private var showAlert = false
    @State private var authViewModel = AuthViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    private func isInputValid() -> Bool {
        return !subject.isEmpty && !message.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Message")) {
                    TextField("Subject", text: $subject)
                }
                
                Section(header: Text("Message")) {
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                }
            }
            .onAppear{
                Task{
                    if let userID = Auth.auth().currentUser?.uid {
                        authViewModel.fetchUserData(userID: userID)
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                    }
                }
            }
            .navigationBarTitle("Raise New Request", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
                if isInputValid() {
                    authViewModel.addSupportTicket(userID: authViewModel.userID, name: authViewModel.userName, email: authViewModel.userEmail, message: message, subject: subject)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showAlert = true
                }
            }) {
                Text("Send")
                    .foregroundColor(.blue)
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Form"),
                    message: Text("Please fill in all fields to send your request."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct CreateIssue_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return CreateIssue().environmentObject(themeManager)
    }
}


