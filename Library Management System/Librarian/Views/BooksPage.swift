import SwiftUI

struct EmptyPage: View {
    
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    @EnvironmentObject var themeManager: ThemeManager
   
    var body: some View {
        ZStack{
            Text("No data found.")
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}

struct BooksPage: View {
    
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var ConfiViewMmodel: ConfigViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State var isPageLoading: Bool = true
    @State private var searchText = ""
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing: 26){
                    if(!LibViewModel.allBooks.isEmpty){
                        ScrollView(showsIndicators: false){
                            VStack{
                                ForEach(LibViewModel.allBooks, id: \..id){ book in
                                    NavigationLink(destination:UpdateBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewMmodel, currentBookId: book.id)){
                                        HStack{
                                            AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                image.resizable()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 100,height: 140)
                                            .cornerRadius(8)
                                            VStack(alignment: .leading, spacing: 5){
                                                Spacer()
                                                HStack{
                                                    Image(systemName: "star.fill").font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(Color(.systemYellow))
                                                    Text(String(format: "%.1f", book.bookRating)).font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(Color(.systemYellow))
                                                    
                                                }.padding(.bottom, 5)
                                                Text("\(book.bookName)")
                                                    .multilineTextAlignment(.leading)
                                                    .font(.system(size: 22, weight: .bold))
                                                    .lineLimit(2)
                                                Text("\(book.bookAuthor)")
                                                    .multilineTextAlignment(.leading)
                                                    .font(.system(size: 19, weight: .semibold))
                                                    .lineLimit(1)
                                                    .foregroundColor(Color(.systemGray))
                                            }
                                            .padding(5)
                                            Spacer()
                                            VStack{
                                                Image(systemName: "chevron.right")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 15))
                                            }
                                        }
                                        .padding(10)
                                        .cornerRadius(8)
                                    }
                                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                    Divider()
                                }
                            }
                        }
                    }
                    else{
                        EmptyPage()
                    }
                }.searchable(text: $searchText)
                .padding(10)
                .background(.black.opacity(0.05))
                .navigationTitle("Books")
                .navigationBarItems(trailing: NavigationLink( destination: AddBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewMmodel) ){
                    Image(systemName: "plus")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 22, weight: .medium))
                })
                .task {
                    LibViewModel.getBooks()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    isPageLoading.toggle()
                }
                .onAppear(
                    perform: {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
                            Task{
                                LibViewModel.getBooks()
                            }
                        }
                    }
                )
            }
        }
    }
    
    //}
}

struct BPPrev: View {
    
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    
    var body: some View {
        BooksPage(LibViewModel: LibViewModel, ConfiViewMmodel: ConfiViewModel)
    }
}


struct BPPrev_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return BPPrev()
            .environmentObject(themeManager)
    }
}
