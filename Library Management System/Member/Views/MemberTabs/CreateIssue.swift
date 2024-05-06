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
    
    @State private var phoneNumber: String = ""
    @State private var message: String = ""
    @State private var subject: String = ""
    @State private var showAlert = false
    @State private var authViewModel = AuthViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    private func isInputValid() -> Bool {
        return !subject.isEmpty && !message.isEmpty && !phoneNumber.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("If you have any queries, feel free to write them here. We're here to help!").padding().textCase(nil)) {
                    
                    CustomTextField(text: $phoneNumber, placeholder: "Phone Number")
                        .keyboardType(.numberPad)
                    
                    TextField("Subject", text: $subject)
                        .font(.title3)
                        .padding(12)
                        .background(Color(.systemGray5))
                        .cornerRadius(15)
                        .padding(5)
                        .lineLimit(30)
                    
                    TextField("Message", text: $message)
                        .font(.title3)
                        .padding(12)
                        .background(Color(.systemGray5))
                        .cornerRadius(15)
                        .padding(5)
                        .lineLimit(30)
                }
                
                PrimaryCustomButton(action: {
                    if isInputValid() {
                        authViewModel.addSupportTicket(userID: authViewModel.userID, name: authViewModel.userName, email: authViewModel.userEmail, phoneNumber: phoneNumber, message: message, subject: subject)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                }, label: "Send")
                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                Spacer()
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
            .padding()
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


