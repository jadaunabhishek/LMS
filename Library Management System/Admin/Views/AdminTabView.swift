//
//  AdminTabView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI

struct AdminTabView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var staffViewModel: StaffViewModel
    @ObservedObject var userAuthViewModel: AuthViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    
    @State var tabSelection: Int = 0
    
    var body: some View {
        TabView (selection: $tabSelection) {
            AdminHomeView(adminTabSelection: $tabSelection, librarianViewModel: LibViewModel, staffViewModel: staffViewModel, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                AdminCategoriesView(configViewModel: configViewModel, libViewModel: LibViewModel)
                    .tabItem {
                        Image(systemName: "square.split.2x2.fill")
                        Text("Categories")
                    }
                    .tag(1)
                AdminStaffView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Staff")
                    }
                    .tag(2)
                AdminFineView(configViewModel: configViewModel)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Fine")

                    }
                    .tag(3)
            }
        
        .accentColor(themeManager.selectedTheme.primaryThemeColor)
        .navigationBarHidden(true)
    }
}

struct AdminTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var staffViewModel = StaffViewModel()
        @StateObject var userAuthViewModel = AuthViewModel()
        @StateObject var configViewModel = ConfigViewModel()
        return AdminTabView(LibViewModel: LibViewModel, staffViewModel: staffViewModel, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
            .environmentObject(themeManager)
    }
}
