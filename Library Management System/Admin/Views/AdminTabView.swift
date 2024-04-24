//
//  AdminTabView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI

struct AdminTabView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        TabView {
            AdminHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            AdminStaffView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Staff")
                }
        }
        .accentColor(themeManager.selectedTheme.primaryThemeColor)
        .navigationBarHidden(true)
    }
}

struct AdminTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminTabView()
            .environmentObject(themeManager)
    }
}
