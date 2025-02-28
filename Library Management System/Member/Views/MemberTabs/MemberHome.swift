import SwiftUI
import EventKit
import FirebaseAuth
import TipKit


func requestAccessToCalendar(completion: @escaping (Bool) -> Void) {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { granted, error in
        DispatchQueue.main.async {
            if granted && error == nil {
                print("Access to calendar events granted.")
                completion(true)
            } else {
                if let error = error {
                    print("Error requesting access: \(error.localizedDescription)")
                } else {
                    print("Access to calendar events was denied.")
                }
                completion(false)
            }
        }
    }
}


struct MemberHome: View {
    @State var category: String = ""
    @Binding var tabSelection: Int
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @State private var hasCalendarAccess = false
    @ObservedObject var configViewModel: ConfigViewModel
    @ObservedObject var MemViewModel: UserBooksModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var isLoading: Bool = true
    
    var tipWelcome = welcomingTip()
    
    var categories: [String] {
        configViewModel.currentConfig.isEmpty ? [] : configViewModel.currentConfig[0].categories
    }
    
    var toprated: [Book] {
        LibViewModel.topRatedBooks
    }
    
    var trending: [Book] {
        LibViewModel.trendingBooks
    }
    
    var categoryBooks: [Book] {
        var booksToFilter = LibViewModel.allBooks.filter { book in
            book.bookCategory.contains(category)
        }
        return booksToFilter
    }
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let newwidth = screenWidth * 0.43
        let newheight = screenWidth * 0.35
        NavigationStack {
            if(!isLoading){
                ScrollView(.vertical, showsIndicators: false) {
                    TipView(tipWelcome)
                        .padding([.leading, .trailing, .bottom])
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                                ZStack(alignment: .bottomLeading) {
                                    
                                    Rectangle()
                                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                        .frame(width: 230, height: 130)
                                    
                                    HStack {
                                        Text("My Books")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Image(systemName: "book")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding()
                                }.onTapGesture {
                                    tabSelection = 3
                                }
                            
                            NavigationLink(destination: UserHistory(LibViewModel: LibViewModel)) {
                                ZStack(alignment: .bottomLeading) {
                                    Rectangle()
                                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                        .frame(width: 210, height: 130)
                                    HStack {
                                        Text("History").font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Image(systemName: "square.stack.3d.up.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }.padding()
                                }
                            }
                        }.padding()
                    }
                    
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            HStack{
                                Text("Top Rated")
                                    .font(.title2).fontWeight(.semibold).padding(.leading, 20)
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    ForEach(toprated.prefix(10), id: \.id) { book in
                                        NavigationLink(destination: MemberBookDetailView(
                                            book: book,
                                            userData: authViewModel,
                                            bookRequest: MemViewModel,
                                            prebookRequest: MemViewModel
                                        )){
                                            HStack(spacing: 5) {
                                                VStack{
                                                    AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                        image.resizable()
                                                    } placeholder: {
                                                        Rectangle().fill(Color(.systemGray4))
                                                        .frame(width: 80, height: 120)
                                                    }
                                                    .frame(width: 80, height: 120)
                                                    .cornerRadius(8)
                                                }
                                                VStack (alignment: .leading){
                                                    Spacer()
                                                    HStack{
                                                        Image(systemName: "star.fill")
                                                        Text(String(format: "%.1f", book.bookRating))
                                                    }
                                                    .font(.caption)
                                                    .bold()
                                                    .foregroundStyle(Color(.systemGray))
                                                    .padding(.bottom, 5)
                                                    Text("\(book.bookName)")
                                                        .multilineTextAlignment(.leading)
                                                        .font(.title3)
                                                        .bold()
                                                        .lineLimit(2)
                                                    Text("\(book.bookAuthor)")
                                                        .multilineTextAlignment(.leading)
                                                        .font(.callout)
                                                        .bold()
                                                        .lineLimit(1)
                                                }.frame(width: 130)
                                                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                            }
                                            .padding(5)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                
                            }
                            
                        }.padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: themeManager.gradientColors(for: colorScheme)),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        VStack(alignment: .leading){
                            HStack{
                                Text("Categories").font(.title2).fontWeight(.semibold).padding(.leading, 20)
                                Spacer()
                                NavigationLink(destination: MemberCategoryListView(LibViewModel: LibViewModel, configViewModel: configViewModel)){
                                    HStack{
                                        Text("See all")
                                        Image(systemName: "chevron.right")
                                    }.padding(.trailing, 10)
                                }
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    ForEach(categories.prefix(5), id: \.self) { category in
                                        
                                        NavigationLink(destination: MemberCategoryView(category: category, configViewModel: configViewModel, librarianViewModel: LibViewModel)) {
                                            VStack(alignment: .leading){
                                                ZStack(alignment:.leading){
                                                    Rectangle()
                                                        .fill(themeManager.randomColor())
                                                        .cornerRadius(12)
                                                    VStack(alignment:.leading){
                                                        Spacer()
                                                        Text("\(category)")
                                                            .font(.title2)
                                                            .lineLimit(1)
                                                            .multilineTextAlignment(.leading)
                                                            .truncationMode(.tail)
                                                            .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                                                            .padding()
                                                    }
                                                }
                                                .frame(width: newwidth, height: newheight)
                                            }.padding(3)
                                            
                                            
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                
                            }
                            
                        }
                        .padding(.vertical, 10)
                            .cornerRadius(5)
                        
                        
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("Trending")
                                    .font(.title2).fontWeight(.semibold).padding(.leading, 20)
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    ForEach(trending.prefix(10), id: \.id) { book in
                                        NavigationLink(destination: MemberBookDetailView(
                                            book: book,
                                            userData: authViewModel,
                                            bookRequest: MemViewModel,
                                            prebookRequest: MemViewModel
                                        )){
                                            HStack(spacing: 5) {
                                                VStack{
                                                    AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                        image.resizable()
                                                    } placeholder: {
                                                        Rectangle().fill(Color(.systemGray4))
                                                        .frame(width: 80, height: 120) 
                                                    }
                                                    .frame(width: 80, height: 120)
                                                    .cornerRadius(8)
                                                }
                                                VStack (alignment: .leading){
                                                    Spacer()
                                                    HStack{
                                                        Image(systemName: "star.fill")
                                                        Text(String(format: "%.1f", book.bookRating))
                                                    }
                                                    .font(.caption)
                                                    .bold()
                                                    .foregroundStyle(Color(.systemGray))
                                                    .padding(.bottom, 5)
                                                    Text("\(book.bookName)")
                                                        .multilineTextAlignment(.leading)
                                                        .font(.title3)
                                                        .bold()
                                                        .lineLimit(2)
                                                    Text("\(book.bookAuthor)")
                                                        .multilineTextAlignment(.leading)
                                                        .font(.callout)
                                                        .bold()
                                                        .lineLimit(1)
                                                }.frame(width: 130)
                                                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                            }
                                            .padding(5)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                
                            }
                            
                        }.padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: themeManager.gradientColors(for: colorScheme)),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        
                    }
                    .navigationTitle("Trove")
                    .navigationBarItems(trailing: NavigationLink(destination: ProfileView(LibViewModel: LibViewModel, configViewModel: configViewModel), label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
                    }))
                }
            }
                else{
                    ProgressView()
                        .controlSize(.large)
                }
            }
                .onAppear {
                    Task{
                        if let currentUser = Auth.auth().currentUser?.uid{
                            requestAccessToCalendar { granted in
                                self.hasCalendarAccess = granted
                                LibViewModel.fetchUserData(userID: currentUser)
                                authViewModel.fetchUserData(userID: currentUser)
                            }
                            await createCalendarEvents(LibViewModel: LibViewModel, userId: currentUser)
                            LibViewModel.getTopRatedBooks()
                            LibViewModel.getTrendingBooks()
                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                            isLoading = false
                        }
                        
                    }
                   
                    
                    
                }
        }
    }


struct MemberHome_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var ConfiViewModel = ConfigViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var MemViewModel = UserBooksModel()
        @StateObject var authViewModel = AuthViewModel()
        @State var int: Int = 0
        let themeManager = ThemeManager()
        return MemberHome(tabSelection: $int, LibViewModel: LibViewModel, authViewModel: authViewModel, configViewModel: ConfiViewModel, MemViewModel: MemViewModel)
            .environmentObject(themeManager)
    }
}
