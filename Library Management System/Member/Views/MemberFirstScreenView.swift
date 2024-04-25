//
//  FirstScreenView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.

import SwiftUI

struct MemberFirstScreenView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var applyMembership = false
    
    var body: some View {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                Filter()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Staff")
                    }
            }
            .accentColor(themeManager.selectedTheme.primaryThemeColor)
            .navigationBarBackButtonHidden(true)
    }
}

struct MemberFirstScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MemberFirstScreenView()
            .environmentObject(themeManager)
    }
}
