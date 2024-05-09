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
    @State var tabSelection: Int = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MemberHome(tabSelection: $tabSelection, LibViewModel: LibViewModel, configViewModel: ConfiViewModel)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }.tag(1)
            
            Books(themeManager: themeManager, MemViewModel: memModelView, configViewModel: ConfiViewModel)
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
