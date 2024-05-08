//
//  Library_Management_SystemApp.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI
import Firebase

@main
struct Library_Management_SystemApp: App {
    @StateObject var LibModel = LibrarianViewModel()
    @AppStorage("emailLoggedIn") var emailLoggedIn = "false"
    
    // Admin side parameters
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var staffViewModel = StaffViewModel()
    @StateObject var userAuthViewModel = AuthViewModel()
    @StateObject var configViewModel = ConfigViewModel()
    @StateObject var memModelView = UserBooksModel()
    
    @StateObject var confiModel = ConfigViewModel()
    @StateObject var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            if emailLoggedIn == "user" {
                Membership()
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                            LibModel.rateReview(bookId: "0LTr2axjCUCzyy9NGnRV", rating: 4, review: "Good Book")
                        }
                    }
            }
            else if emailLoggedIn == "admin" {
                AdminTabView(themeManager: themeManager, LibViewModel: LibViewModel, staffViewModel: staffViewModel, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                            LibModel.rateReview(bookId: "0LTr2axjCUCzyy9NGnRV", rating: 4, review: "Good Book")
                        }
                    }
            }
            else if emailLoggedIn == "librarian" {
                LibrarianFirstScreenView(LibModelView: LibModel, ConfiViewModel: confiModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                            LibModel.rateReview(bookId: "0LTr2axjCUCzyy9NGnRV", rating: 4, review: "Good Book")
                        }
                    }
            }
            else if emailLoggedIn == "member" {
                MemberTabView(themeManager: themeManager, memModelView: memModelView, ConfiViewModel: configViewModel, LibViewModel: LibViewModel, auth: userAuthViewModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                            LibModel.rateReview(bookId: "0LTr2axjCUCzyy9NGnRV", rating: 4, review: "Good Book")
                        }
                    }
            }
            else {
                ContentView()
                    .transition(.move(edge: .trailing))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                            LibModel.rateReview(bookId: "0LTr2axjCUCzyy9NGnRV", rating: 4, review: "Good Book")
                        }
                    }
            }
        }
    }
    init(){
        FirebaseApp.configure()
    }
}
