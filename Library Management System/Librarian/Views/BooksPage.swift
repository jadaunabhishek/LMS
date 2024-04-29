import SwiftUI

struct EmptyPage: View {
    
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        ZStack{
//            Circle()
//                .trim(from: 0, to: 0.7)
//                .stroke(Color("PrimaryColor"), lineWidth: 10)
//                .frame(width: 100, height: 100)
//                .rotationEffect(Angle(degrees: Double(degree)))
//                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
//                .onAppear{
//                    degree = 270 + 360
//                    spinnerLength = 0
//                }
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
        NavigationStack{
            ZStack{
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack(spacing: 26){
                    HStack{
                        Spacer()
                        NavigationLink( destination: AddBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewMmodel) ){
                            Image(systemName: "plus")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 22, weight: .medium))
                        }
                    }
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
                .task {
                    LibViewModel.getBooks()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    isPageLoading.toggle()
                }
                .onAppear(
                    perform: {
                        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { time in
                            Task{
                                LibViewModel.getBooks()
                            }
                        }
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
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
