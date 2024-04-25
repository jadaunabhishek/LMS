import SwiftUI

struct LibrarianFirstScreenView: View {
    @State private var showNotifications = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibModelView: LibrarianViewModel
    @ObservedObject var ConfiViewModel: ConfigViewModel

    var body: some View {
        NavigationView {
            TabView {
                BooksPage(LibViewModel: LibModelView, ConfiViewMmodel: ConfiViewModel)
                    .tabItem {
                        Image(systemName: "book.closed")
                        Text("Books")
                    }
                AdminHomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                MembersView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Member")
                    }
            }
            .accentColor(themeManager.selectedTheme.primaryThemeColor)
            .navigationBarTitle("Library Management", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showNotifications = true
            }) {
                Image(systemName: "bell.fill").imageScale(.large)
            })
            .accentColor(.yellow)
            .background(NavigationLink(destination: NotificationsView(viewModel: NotificationsViewModel()), isActive: $showNotifications) {
                EmptyView()
            })
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
