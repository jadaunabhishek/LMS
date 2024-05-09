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

struct Review: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @State var bookId: String = ""
    @State var loanId: String = ""
    
    @State private var review: String = ""
    @State private var rating: Int = 0
    @State private var subject: String = ""
    @State private var showAlert = false
    @State private var authViewModel = AuthViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    private func isInputValid() -> Bool {
        return rating != 0 && !review.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .center){
                    HStack{
                        Button(action:{
                            rating = 1
                        }){
                            if(rating >= 1){
                                Image(systemName: "star.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            else{
                                Image(systemName: "star")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                        Button(action:{
                            rating = 2
                        }){
                            if(rating >= 2){
                                Image(systemName: "star.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            else{
                                Image(systemName: "star")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                        Button(action:{
                            rating = 3
                        }){
                            if(rating >= 3){
                                Image(systemName: "star.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            else{
                                Image(systemName: "star")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                        Button(action:{
                            rating = 4
                        }){
                            if(rating >= 4){
                                Image(systemName: "star.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            else{
                                Image(systemName: "star")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                        Button(action:{
                            rating = 5
                        }){
                            if(rating >= 5){
                                Image(systemName: "star.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            else{
                                Image(systemName: "star")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.yellow)
                .font(.system(.title))
                Form {
                    Section(header: Text("Review")) {
                        TextEditor(text: $review)
                            .frame(minHeight: 100)
                    }
                }
            }
            .padding(.vertical,10)
            .onAppear{
                Task{
                    if let userID = Auth.auth().currentUser?.uid {
                        authViewModel.fetchUserData(userID: userID)
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                    }
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitle("Raise New Request", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
                if isInputValid() {
                    LibViewModel.rateReview(bookId: bookId, rating: rating, review: review, loanId: loanId)
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

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var LibViewModel = LibrarianViewModel()
        return Review(LibViewModel: LibViewModel).environmentObject(themeManager)
    }
}


