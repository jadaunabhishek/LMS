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
    
    @State var isPageLoading: Bool = true
    
    var body: some View {
        //NavigationView{
            ZStack{
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack(spacing: 26){
                    if(!LibViewModel.allBooks.isEmpty){
                        ScrollView{
                            VStack{
                                ForEach(LibViewModel.allBooks, id: \..id){ book in
                                    NavigationLink(destination:UpdateBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewMmodel, currentBookId: book.id)){
                                        HStack(){
                                            AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                image.resizable()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 60,height: 80)
                                            .cornerRadius(8)
                                            VStack(alignment: .leading, spacing: 5){
                                                Text("\(book.bookName)")
                                                    .font(.system(size: 18, weight: .bold))
                                                Text("\(book.bookAuthor)")
                                                    .font(.system(size: 18, weight: .regular))
                                            }
                                            .padding(5)
                                            Spacer()
                                            VStack{
                                                Image(systemName: "chevron.right")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 25))
                                            }
                                        }
                                        .padding(10)
                                        .background(.white)
                                        .cornerRadius(8)
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    else{
                        EmptyPage()
                    }
                }
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
    //}
}

struct BPPrev: View {
    
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    
    var body: some View {
        BooksPage(LibViewModel: LibViewModel, ConfiViewMmodel: ConfiViewModel)
    }
}

#Preview {
    BPPrev()
}
