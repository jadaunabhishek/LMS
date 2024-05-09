//
//  MemberTabView.swift
//  Library Management System
//
//  Created by admin on 25/04/24.
//

import SwiftUI

struct MemberTabView: View {
    @ObservedObject var themeManager: ThemeManager
    @State private var applyMembership = false
    @ObservedObject var memModelView = UserBooksModel()
    @ObservedObject var ConfiViewModel = ConfigViewModel()
    @ObservedObject var LibViewModel = LibrarianViewModel()
    @ObservedObject var auth = AuthViewModel()
    
    var body: some View {
        TabView {
            MemberHome(themeManager: themeManager, LibViewModel: LibViewModel, configViewModel: ConfiViewModel)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }
            
            Books(themeManager: themeManager, MemViewModel: memModelView, configViewModel: ConfiViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            Records(LibViewModel: LibViewModel)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("My Books")
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
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        MemberTabView(themeManager: themeManager, memModelView: memModelView, ConfiViewModel: ConfiViewModel)
    }
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MTVPrev(themeManager: themeManager)
            .environmentObject(themeManager)
    }
}
