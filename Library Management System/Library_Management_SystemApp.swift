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
    @StateObject var confiModel = ConfigViewModel()
    @StateObject var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .task {
                    do{
                        await themeManager.setBaseTheme()
                        LibModel.rateReview(bookId: "0LTr2axjCUCzyy9NGnRV", rating: 4, review: "Good Book")
                    }
                }
        }
    }
    init(){
        FirebaseApp.configure()
    }
}
