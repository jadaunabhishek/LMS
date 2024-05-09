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
    @State var tabSelection: Int = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MemberHome(tabSelection: $tabSelection, LibViewModel: LibViewModel, authViewModel: auth, configViewModel: ConfiViewModel, MemViewModel: memModelView)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }.tag(1)
            
            Books(MemViewModel: memModelView, configViewModel: ConfiViewModel, authViewModel: auth, LibViewModel: LibViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(2)
            
            Records(LibViewModel: LibViewModel)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("My Books")
                }.tag(3)
            
            Support(authViewModel: auth)
                .tabItem {
                    Image(systemName: "person.line.dotted.person.fill")
                    Text("Support")
                }.tag(4)
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
        MemberTabView(memModelView: memModelView, ConfiViewModel: ConfiViewModel, LibViewModel: LibViewModel, auth: authViewModel)
    }
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MTVPrev()
            .environmentObject(themeManager)
    }
}
