//
//  FirstScreenView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI

struct MemberFirstScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        TabView {
            Membership()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            Filter()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
        }
        .navigationBarHidden(true)
    }
}

struct MemberFirstScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MemberFirstScreenView()
            .environmentObject(themeManager)
    }
}
