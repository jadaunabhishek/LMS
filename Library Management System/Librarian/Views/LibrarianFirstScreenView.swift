import SwiftUI

struct LibrarianFirstScreenView: View {
    @State private var showNotifications = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            TabView {
                AdminHomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }

                AdminStaffView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Staff")
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

// Preview for SwiftUI Canvas
struct LibrarianFirstScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LibrarianFirstScreenView().environmentObject(ThemeManager())
    }
}

