import SwiftUI

struct LibrarianFirstScreenView: View {
    @State private var showNotifications = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibModelView: LibrarianViewModel
    @ObservedObject var ConfiViewModel: ConfigViewModel
    @StateObject var auth = AuthViewModel()

    var body: some View {
            TabView {
                
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
                
                SupportView(authViewModel: auth)
                    .tabItem {
                        Image(systemName: "person.line.dotted.person.fill")
                        Text("Support")
                    }
            }
            .accentColor(themeManager.selectedTheme.primaryThemeColor)
            .navigationBarHidden(true)
            .task {
                Task{
                    LibModelView.calculateFine()
                }
            }
            .onAppear(
                perform: {
                    Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { time in
                        Task{
                            LibModelView.calculateFine()
                        }
                    }
                }
            )
    }
}

struct LFSPrev: View {
    
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    @StateObject var auth = AuthViewModel()
    
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
