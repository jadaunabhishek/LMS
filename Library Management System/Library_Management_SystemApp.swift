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
    @StateObject var themeManager = ThemeManager()
    @StateObject var LibModel = LibrarianViewModel()
    @StateObject var confiModel = ConfigViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
//             AdminCategoriesView(configViewModel: confiModel)
//                        LibrarianFirstScreenView(LibModelView: LibModel, ConfiViewModel: confiModel)
//                            .environmentObject(themeManager)
        }
    }
    init(){
        FirebaseApp.configure()
    }
}
