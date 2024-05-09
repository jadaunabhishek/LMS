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
    @State private var hasCalendarAccess = false
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    @ObservedObject var MemViewModel: UserBooksModel
    @EnvironmentObject var themeManager: ThemeManager
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
    
    var body: some View {
        NavigationView {
            if(!isLoading){
                ScrollView(.vertical, showsIndicators: false) {
                    TipView(tipWelcome)
                        .padding([.leading, .trailing, .bottom])
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            NavigationLink(destination: Books()) {
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
                                }
                                
                            }
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
                        }.padding()
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("Top Rated ")
                                .font(.title2).fontWeight(.semibold).padding(.leading, 20)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(toprated.prefix(9), id: \.id) { book in
                                    
                                    NavigationLink(destination: MemberBookDetailView(
                                        book: book,
                                        userData: AuthViewModel(),
                                        bookRequest: UserBooksModel(),
                                        prebookRequest: UserBooksModel()
                                    )){
                                        HStack(spacing: 5) {
                                            VStack{
                                                AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                    ProgressView()
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
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                
                            }
                            
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
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(categories.prefix(5), id: \.self) { category in
                                    
                                    NavigationLink(destination: Books()) {
                                        VStack(alignment: .leading){
                                            Text("Featured Collection").multilineTextAlignment(.leading).font(.callout).fontWeight(.semibold)
                                            ZStack(alignment:.leading){
                                                Rectangle()
                                                    .fill(randomColor())
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
                                            .frame(width: 160, height: 180)
                                        }.padding(3)
                                        
                                        
                                    }
                                    .buttonStyle(PlainButtonStyle())
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
                                        userData: AuthViewModel(),
                                        bookRequest: UserBooksModel(),
                                        prebookRequest: UserBooksModel()
                                    )){
                                        HStack(spacing: 5) {
                                            VStack{
                                                AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                    ProgressView()
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
                                    .padding(5)
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
                .navigationTitle("Hello \(LibViewModel.currentMember[0].name.split(separator: " ")[0])")
                .navigationBarItems(trailing: NavigationLink(destination: ProfileView(LibViewModel: LibViewModel, configViewModel: configViewModel), label: {
                    Image(systemName: "person.crop.circle")
                        .font(.title3)
                        .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
                }))
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
                    }
                    await createCalendarEvents(LibViewModel: LibViewModel, userId: currentUser)
                    LibViewModel.fetchUserData(userID: currentUser)
                    LibViewModel.getTopRatedBooks()
                    LibViewModel.getTrendingBooks()
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    isLoading = false
                }
                
            }
        }
    }
}

func randomColor() -> Color {
    let systemColors: [Color] = [.red, .green, .blue, .orange, .yellow, .pink, .purple, .teal, .cyan, .indigo, .brown, .gray, .mint]
    return systemColors.randomElement() ?? .red
}

struct MemberHome_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var ConfiViewModel = ConfigViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var MemViewModel = UserBooksModel()
        let themeManager = ThemeManager()
        return MemberHome(LibViewModel: LibViewModel, configViewModel: ConfiViewModel, MemViewModel: MemViewModel)
            .environmentObject(themeManager)
    }
}
