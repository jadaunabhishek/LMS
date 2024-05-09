import SwiftUI
import FirebaseAuth

struct LibrarianFirstScreenView: View {
    @State private var showNotifications = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibModelView: LibrarianViewModel
    @ObservedObject var ConfiViewModel: ConfigViewModel
    @StateObject var auth = AuthViewModel()
    @StateObject var staffViewModel = StaffViewModel()
    
    @State var tabSelection: Int = 1
    @State var actionSelection: Option = .CheckOut
    
    var body: some View {
        TabView(selection: $tabSelection){
            
            Dashboard(librarianViewModel: LibModelView, staffViewModel: staffViewModel, userAuthViewModel: auth, configViewModel: ConfiViewModel, tabSelection: $tabSelection, actionSelection: $actionSelection)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)
            
            NotificationsView(LibViewModel: LibModelView, configViewModel: ConfiViewModel, staffViewModel: staffViewModel, selectedOption: $actionSelection)
                .tabItem {
                    Image(systemName: "person.bust.fill")
                    Text("Actions")
                }
                .tag(2)
            
            BooksPage(LibViewModel: LibModelView, ConfigViewModel: ConfiViewModel)
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("Books")
                }
                .tag(3)
            
            SupportView(authViewModel: auth)
                .tabItem {
                    Image(systemName: "person.line.dotted.person.fill")
                    Text("Support")
                }
                .tag(4)
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
