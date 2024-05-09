//
//  AdminSubCategories.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import SwiftUI

struct AdminSubCategoriesView: View {
    
    @State var category: String
    @State private var searchText = ""
    @State private var isSheetPresented = false
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
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    if !filteredBooks.isEmpty {
                        ForEach(filteredBooks, id: \.id) { book in
                            NavigationLink(destination: BookDetailView(LibViewModel: librarianViewModel, ConfiViewModel: configViewModel, currentBookId: book.id)){
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
            .navigationBarItems(leading: Spacer(),trailing:
                                    Button(action: {
                isSheetPresented.toggle()
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.title3)
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
            }
                .sheet(isPresented: $isSheetPresented, content: {
                    UpdateCategoriesView(isSheetPresented: $isSheetPresented, configViewModel: configViewModel, category: category)
                        .presentationDetents([.fraction(0.40)])
                })
            )
            .task {
                librarianViewModel.getBooks()
            }
        }
    }
}



struct AdminSubCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var configViewModel = ConfigViewModel()
        @StateObject var librarianViewModel = LibrarianViewModel()
        return AdminSubCategoriesView(category: "Fantasy", configViewModel: configViewModel, librarianViewModel: librarianViewModel)
            .environmentObject(themeManager)
    }
}
