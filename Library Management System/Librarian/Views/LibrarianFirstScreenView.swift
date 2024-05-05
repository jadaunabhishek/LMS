import SwiftUI

struct LibrarianFirstScreenView: View {
    @State private var showNotifications = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibModelView: LibrarianViewModel
    @ObservedObject var ConfiViewModel: ConfigViewModel

    var body: some View {
            TabView {
                LibrarianHomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                NotificationsView(LibViewModel: LibModelView)
                    .tabItem {
                        Image(systemName: "person.bust.fill")
                        Text("Actions")
                    }
                
                BooksPage(LibViewModel: LibModelView, ConfiViewMmodel: ConfiViewModel)
                    .tabItem {
                        Image(systemName: "book.closed")
                        Text("Books")
                    }
                
                MembersView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Member")
                    }
            }
            .accentColor(themeManager.selectedTheme.primaryThemeColor)
            .navigationBarHidden(true)
    }
}

struct LFSPrev: View {
    
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    
    var body: some View {
        LibrarianFirstScreenView(LibModelView: LibViewModel, ConfiViewModel: ConfiViewModel)
    }
}

struct LFSPrev_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return LFSPrev()
            .environmentObject(themeManager)
    }
}
