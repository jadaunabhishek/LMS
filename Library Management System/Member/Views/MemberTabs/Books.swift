//
//  Books.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 27/04/24.
//
import SwiftUI
struct Books: View {
    @State private var searchText = ""
    @State private var isFilterButtonTapped = false
    @State private var showFilterOptions = false
    @ObservedObject var MemViewModel = UserBooksModel()
    @ObservedObject var ConfiViewMmodel = ConfigViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @State var isPageLoading: Bool = true
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return MemViewModel.allBooks
        } else {
            return MemViewModel.allBooks.filter { $0.bookName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    VStack {
                        SearchBar(text: $searchText, isFilterButtonTapped: $isFilterButtonTapped, showFilterOptions: $showFilterOptions)
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                    .sheet(isPresented: $showFilterOptions) {
                        FilterOptions(userBooksModel: MemViewModel)
                            .presentationDetents([.medium])
                    }
                    
                    VStack{
                        VStack {
                            if !filteredBooks.isEmpty {
                                ForEach(filteredBooks, id: \.id) { book in
                                    NavigationLink(destination: MemberBookDetailView(
                                        book: book,
                                        userData: AuthViewModel(),
                                        bookRequest: UserBooksModel(),
                                        prebookRequest: UserBooksModel()
                                    )){
                                        BookRow(book: book)
                                    }
                                }
                            } else {
                                Text("No books found")
                            }
                        }
                        
                    }
                }
                .padding(10)
            }
            .navigationTitle("Books")
            .task {
                MemViewModel.getBooks()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isPageLoading.toggle()
            }
        }
    }
}


struct BookRow: View {
    let book: Book
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: book.bookImageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 80)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Books")
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(book.bookName)")
                    .font(.system(size: 18, weight: .bold))
                Text("\(book.bookAuthor)")
                    .font(.system(size: 18, weight: .regular))
            }
            .foregroundColor(themeManager.selectedTheme.bodyTextColor)
            .padding(5)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 25))
        }
        .padding(10)
        .cornerRadius(8)
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
