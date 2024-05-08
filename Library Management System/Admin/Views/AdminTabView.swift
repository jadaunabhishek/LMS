//
//  AdminTabView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI


struct AdminTabView: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel = LibrarianViewModel()
    @ObservedObject var staffViewModel = StaffViewModel()
    @ObservedObject var userAuthViewModel = AuthViewModel()
    @ObservedObject var configViewModel = ConfigViewModel()
    
    var body: some View {
            TabView {
                AdminHomeView(librarianViewModel: LibViewModel, staffViewModel: staffViewModel, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                AdminCategoriesView(configViewModel: ConfigViewModel())
                    .tabItem {
                        Image(systemName: "square.split.2x2.fill")
                        Text("Categories")
                    }
                AdminStaffView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Staff")
                    }
                AdminFineView(configViewModel: configViewModel)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Fine")

                    }
            }
        
        .accentColor(themeManager.selectedTheme.primaryThemeColor)
        .navigationBarHidden(true)
    }
}

struct AdminTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminTabView(themeManager: themeManager)
            .environmentObject(themeManager)
    }
}
