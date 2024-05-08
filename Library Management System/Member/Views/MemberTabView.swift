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
    @ObservedObject var memModelView = UserBooksModel()
    @ObservedObject var ConfiViewModel = ConfigViewModel()
    @ObservedObject var LibViewModel = LibrarianViewModel()
    @ObservedObject var auth = AuthViewModel()
    
    var body: some View {
        TabView {
            MemberHome(LibViewModel: LibViewModel, configViewModel: ConfiViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Books()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Books")
                }
            
            Support(authViewModel: auth)
                .tabItem {
                    Image(systemName: "person.line.dotted.person.fill")
                    Text("Support")
                }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .accentColor(themeManager.selectedTheme.primaryThemeColor)
    }
}



struct MTVPrev: View {
    @StateObject var memModelView = UserBooksModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    
    var body: some View {
        MemberTabView(memModelView: memModelView, ConfiViewModel: ConfiViewModel)
    }
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MTVPrev()
            .environmentObject(themeManager)
    }
}

