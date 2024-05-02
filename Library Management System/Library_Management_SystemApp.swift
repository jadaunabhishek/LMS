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
    @State private var hasCalendarAccess = false
    @StateObject var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do{
                        await createCalendarEvents(LibViewModel: LibModel)
                    }
                }
                .environmentObject(themeManager)
                .onAppear {
                    requestAccessToCalendar { granted in
                        self.hasCalendarAccess = granted
                .task {
                    do{
                        await themeManager.setBaseTheme()
                    }
                }
//             AdminCategoriesView(configViewModel: confiModel)
//                        LibrarianFirstScreenView(LibModelView: LibModel, ConfiViewModel: confiModel)
//                            .environmentObject(themeManager)
        }
    }
    init(){
        FirebaseApp.configure()
    }
}
