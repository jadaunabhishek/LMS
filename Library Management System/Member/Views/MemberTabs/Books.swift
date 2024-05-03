//
//  Books.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 27/04/24.
//


import SwiftUI

struct Books: View {
    
    @ObservedObject var MemViewModel = UserBooksModel()
    @ObservedObject var ConfiViewMmodel = ConfigViewModel()
    
    @State var isPageLoading: Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("BgColor").edgesIgnoringSafeArea(.all)
                ScrollView{
                    VStack{
                        if(!MemViewModel.allBooks.isEmpty){
                            ForEach(MemViewModel.allBooks, id: \..id){ book in
                                NavigationLink(destination: MemberBookDetailView(
                                    book: book,
                                    userData: AuthViewModel(),
                                    bookRequest: UserBooksModel(),
                                    prebookRequest: UserBooksModel()
                                )){
                                    HStack(){
                                        AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 60,height: 80)
                                        .navigationBarBackButtonHidden(true)
                                        .navigationTitle("Books")
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
                                    .foregroundColor(.black)
                                }
                            }
                        }
                        else{
                            Text("No books found")
                        }
                    }
                }
                .padding(10)
            }
            .navigationTitle("Books")
            .background(.black.opacity(0.05))
            .task {
                MemViewModel.getBooks()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isPageLoading.toggle()
            }
        }
    }
}


struct BooksPrev: View {
    @StateObject var memModelView = UserBooksModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    
    var body: some View {
        Books(MemViewModel: memModelView, ConfiViewMmodel: ConfiViewModel)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return BooksPrev()
            .environmentObject(themeManager)
    }
}


