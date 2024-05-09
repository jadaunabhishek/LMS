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
                VStack(alignment: .leading, spacing: 8) {
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
struct BookRow: View {
    let book: Book
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .center){
            HStack(alignment: .center){
                AsyncImage(url: URL(string: book.bookImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle().fill(Color(.systemGray4))
                    .frame(width: 80, height: 120) 
                }
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
        Divider()
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
