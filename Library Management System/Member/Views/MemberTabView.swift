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
    @ObservedObject var memModelView: UserBooksModel
    @ObservedObject var ConfiViewModel: ConfigViewModel
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            MemberHome(LibViewModel: LibViewModel, configViewModel: ConfiViewModel, MemViewModel: memModelView)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }
            
            Books(MemViewModel: memModelView, configViewModel: ConfiViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            Records(LibViewModel: LibViewModel)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("My Books")
                }
            
            Support(authViewModel: authViewModel)
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
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        MemberTabView(memModelView: memModelView, ConfiViewModel: ConfiViewModel, LibViewModel: LibViewModel, authViewModel: authViewModel)
    }
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MTVPrev()
            .environmentObject(themeManager)
    }
}
