import SwiftUI

struct BooksPage: View {
    
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var ConfiViewMmodel: ConfigViewModel
    
    @State var isPageLoading: Bool = true
    
    var body: some View {
        NavigationView{
            VStack{
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
                    Text("No data found.")
                }
            }
            .padding(10)
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
            .navigationTitle("Books")
            .navigationBarItems(trailing: NavigationLink( destination: AddBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewMmodel) ){
                Image(systemName: "plus")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 22, weight: .medium))
            })
            
        }
    }
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
