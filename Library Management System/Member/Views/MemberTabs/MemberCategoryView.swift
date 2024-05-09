//
//  MemberCategoryView.swift
//  Library Management System
//
//  Created by admin on 09/05/24.
//

import SwiftUI

struct MemberCategoryView: View {
    @State var category: String
    @State private var searchText = ""
    @ObservedObject var configViewModel: ConfigViewModel
    @ObservedObject var librarianViewModel: LibrarianViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var filteredBooks: [Book] {
        var booksToFilter = librarianViewModel.allBooks.filter { book in
            book.bookCategory.contains(category)
        }
        
        if !searchText.isEmpty {
            booksToFilter = booksToFilter.filter { $0.bookName.localizedCaseInsensitiveContains(searchText) }
        }
        
        return booksToFilter
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
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
                        VStack{
                            Spacer()
                            Text("No books found.")
                            Spacer()
                        }
                    }
                }
                .searchable(text: $searchText)
            }
            .navigationTitle(category)
            .task {
                librarianViewModel.getBooks()
                try? await Task.sleep(nanoseconds: 50_000_000_000)
        }
    }
}


