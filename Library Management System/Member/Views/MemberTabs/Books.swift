
//  Books.swift
//  Library Management System
//
//  Created by Ishan Joshi on 27/04/24.
//
import SwiftUI

struct Books: View {
    
    @State private var searchText = ""
    @State private var selectedCategories: [String] = []
    @State private var isPageLoading: Bool = true
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var MemViewModel = UserBooksModel()
    @ObservedObject var configViewModel = ConfigViewModel()
    
    var categories: [String] {
        configViewModel.currentConfig.isEmpty ? [] : configViewModel.currentConfig[0].categories
    }
    
    var filteredBooks: [Book] {
        var booksToFilter = searchText.isEmpty ? MemViewModel.allBooks : MemViewModel.allBooks.filter { $0.bookName.localizedCaseInsensitiveContains(searchText) }
        
        if !selectedCategories.isEmpty {
            booksToFilter = booksToFilter.filter { book in
                selectedCategories.contains(book.bookCategory)
            }
        }
        return booksToFilter
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    if selectedCategories.contains(category) {
                                        selectedCategories.removeAll(where: { $0 == category })
                                    } else {
                                        selectedCategories.append(category)
                                    }
                                }) {
                                    Text(category)
                                        .padding(8)
                                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                        .background(selectedCategories.contains(category) ? themeManager.selectedTheme.primaryThemeColor : Color(.systemGray).opacity(0.3))
                                        .overlay(
                                            Rectangle()
                                                .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1)
                                        )
                                }.cornerRadius(8)
                                    .padding(.trailing, 8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    VStack(spacing: 8) {
                        if !filteredBooks.isEmpty {
                            ForEach(filteredBooks, id: \.id) { book in
                                NavigationLink(destination: MemberBookDetailView(
                                    book: book,
                                    userData: AuthViewModel(),
                                    bookRequest: UserBooksModel(),
                                    prebookRequest: UserBooksModel()
                                )){
                                    VStack(alignment: .center){
                                        HStack(alignment: .center){
                                            AsyncImage(url: URL(string: book.bookImageURL)) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Rectangle().fill(Color(.systemGray4))
                                                .frame(width: 80, height: 120)                                     }
                                            .frame(width: 80,height: 120)
                                            .cornerRadius(8)
                                            .padding(.leading, 10)
                                            VStack(alignment: .leading, spacing: 5){
                                                Text("\(book.bookName)")
                                                    .multilineTextAlignment(.leading)
                                                    .font(.headline)
                                                    .bold()
                                                    .lineLimit(2)
                                                
                                                Text("\(book.bookAuthor)")
                                                    .multilineTextAlignment(.leading)
                                                    .font(.subheadline)
                                                    .lineLimit(1)
                                                    .foregroundStyle(Color(.systemGray))
                                                HStack{
                                                    Image(systemName: "star.fill")
                                                    Text(String(format: "%.1f", book.bookRating))
                                                }
                                                .font(.caption)
                                                .bold()
                                                .foregroundStyle(Color(.systemYellow))
                                                .padding(.bottom, 5)
                                            }
                                            .padding(5)
                                            Spacer()
                                            VStack{
                                                Image(systemName: "chevron.right")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.callout)
                                                    .foregroundStyle(Color(.systemGray))
                                            }.padding(.trailing, 10)
                                        }.cornerRadius(8)
                                    }
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6).opacity(0.6))
                                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                    Divider()
                                }
                            }
                        } else {
                            VStack{
                                Spacer()
                                Text("No books found.")
                                Spacer()
                            }
                        }
                    }.navigationTitle("Search")
                }
                .searchable(text: $searchText)
                .refreshable {
                    MemViewModel.getBooks()
                }
            }
        }
        .task {
            MemViewModel.getBooks()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isPageLoading.toggle()
        }
    }
}


//struct BookRow: View {
//    let book: Book
//    @EnvironmentObject var themeManager: ThemeManager
//    @Environment(\.colorScheme) var colorScheme
//    var body: some View {
//        
//    }
//}

struct BooksPrev: View {
    @StateObject var memModelView = UserBooksModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    @ObservedObject var themeManager: ThemeManager
    var body: some View {
        Books(themeManager: themeManager, MemViewModel: memModelView, configViewModel: ConfiViewModel)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return BooksPrev(themeManager: themeManager)
            .environmentObject(themeManager)
    }
}
