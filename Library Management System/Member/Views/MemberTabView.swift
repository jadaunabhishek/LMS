//
//  MemberTabView.swift
//  Library Management System
//
//  Created by admin on 25/04/24.
//

import SwiftUI

struct MemberTabView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var applyMembership = false
    
    var body: some View {
        TabView {
            MemberHome()
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


struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MemberTabView()
            .environmentObject(themeManager)
    }
}
