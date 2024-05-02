//
//  AdminSubCategories.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI
class AdminSubCategoriesViewModel: ObservableObject {
    @ObservedObject var librarianViewModel = LibrarianViewModel()
    init(){
    }
}

struct AdminSubCategoriesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var configViewModel: ConfigViewModel
    @State var ConfiModel = ConfigViewModel()
    @State private var searchKey = ""
    @State private var isSheetPresented = false
    @State var category: String
    @ObservedObject var librarianViewModel = LibrarianViewModel()
    
    var groupedBooks: [String: [Book]] {
        let filteredBooks = librarianViewModel.allBooks.filter { book in
            book.bookCategory.contains(category)
        }
        
        var groupedBooks: [String: [Book]] = [:]
        for book in filteredBooks {
            for subcategory in book.bookSubCategories {
                if var booksInSubcategory = groupedBooks[subcategory] {
                    booksInSubcategory.append(book)
                    groupedBooks[subcategory] = booksInSubcategory
                } else {
                    groupedBooks[subcategory] = [book]
                }
            }
        }
        return groupedBooks
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                ScrollView {
                    ForEach(groupedBooks.sorted(by: { $0.key < $1.key }), id: \.key) { subcategory, books in
                        VStack{
                            HStack() {
                                Text(subcategory)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 2)
                                
                                Spacer()
                                
                                NavigationLink(destination: CardListDetailView(books: groupedBooks[subcategory]!)) {
                                    Text("See All")
                                }
                            }
                            
                            
                            CardListView(books: groupedBooks[subcategory]!)
                        }
                        
                    }
                }.navigationTitle("Sub Categories")
                    .navigationBarItems(leading: Spacer(),trailing:
                                            Button(action: {
                                                isSheetPresented.toggle()
                                            }) {
                                                Image(systemName: "square.and.pencil")
                                                    .font(.title3)
                                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                            }
                                            .sheet(isPresented: $isSheetPresented, content: {
                                                UpdateCategoriesView(isSheetPresented: $isSheetPresented, configViewModel: ConfiModel, category: category)
                                                        .presentationDetents([.fraction(0.40)])
                                            })
                                    )
            }
            .padding()
            .task {
                librarianViewModel.getBooks()
            }
        }
    }
}



struct AdminSubCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminSubCategoriesView(configViewModel: ConfigViewModel(), category: "Fantasy")
            .environmentObject(themeManager)
    }
}
