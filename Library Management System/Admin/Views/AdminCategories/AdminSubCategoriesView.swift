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
    @State var category: String
    @State private var isEditing = false
    @State private var editedSubcategory = ""
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
                ScrollView{
                    
                    ForEach(groupedBooks.sorted(by: { $0.key < $1.key }), id: \.key) { subcategory,books in
                        VStack(alignment: .leading) {
                            HStack {
                                if isEditing {
                                    TextField("", text: $editedSubcategory)
                                        .font(.title2)
                                        .padding(.bottom, 2)
                                    
                                    Button("Done") {
                                        // updateSubcategory(oldSubcategory: subcategory, newSubcategory: editedSubcategory)
                                        isEditing.toggle()
                                        editedSubcategory = ""
                                    }
                                } else {
                                    Text(subcategory)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 2)
                                    
                                    Button(action: {
                                        editedSubcategory = subcategory
                                        isEditing.toggle()
                                    }) {
                                        Image(systemName: "pencil")
                                            .font(.title2)
                                    }
                                    .padding(.trailing)
                                }
                                
                                
                                Spacer()
                                
                                if isEditing{
                                    
                                }
                                else{
                                    NavigationLink(destination: CardListDetailView(books: groupedBooks[subcategory]!)) {
                                            Text("See All")
                                    }

                                }
                                
                            }
                            CardListView(books: groupedBooks[subcategory]!)
                        }
                    }
                }
            }
            .padding()
            .task {
                librarianViewModel.getBooks()
            }
        }
    }
    
    
    //    private func updateSubcategory(oldSubcategory: String, newSubcategory: String) {
    //        for index in 0..<categories.count {
    //            if categories[index].subcategory == oldSubcategory {
    //                categories[index].subcategory = newSubcategory
    //            }
    //        }
    //    }
}


#Preview {
    AdminSubCategoriesView(category: "Sci-Fi")
}
