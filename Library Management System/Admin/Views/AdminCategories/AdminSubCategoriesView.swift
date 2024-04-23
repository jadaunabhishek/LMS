//
//  AdminSubCategories.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminSubCategoriesView: View {
    @State var groupedBooks: [Bok]
    @State private var isEditing = false
    @State private var editedSubcategory = ""
    
    var body: some View {
        let subGroupedBooks = Dictionary(grouping: groupedBooks, by: { $0.subcategory })
        
        NavigationStack {
            VStack(spacing: 10) {
                ScrollView{
                    ForEach(subGroupedBooks.sorted(by: { $0.key < $1.key }), id: \.key) { subcategory, books in
                        VStack(alignment: .leading) {
                            HStack {
                                if isEditing {
                                    TextField("", text: $editedSubcategory)
                                        .font(.title2)
                                        .padding(.bottom, 2)
                                    
                                    Button("Done") {
                                        updateSubcategory(oldSubcategory: subcategory, newSubcategory: editedSubcategory)
                                        isEditing.toggle()
                                        editedSubcategory = ""
                                    }
                                    
                                }
                                
                                else {
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
                                    NavigationLink(destination: cardlists(books: books)){
                                        Text("See All")
                                    }
                                }
                                
                            }
                            CardListView(books: books)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    
    private func updateSubcategory(oldSubcategory: String, newSubcategory: String) {
        for index in 0..<groupedBooks.count {
            if groupedBooks[index].subcategory == oldSubcategory {
                groupedBooks[index].subcategory = newSubcategory
            }
        }
    }
}





struct cardlists: View {
    var books: [Bok]
    var body: some View {
        ForEach(books) { book in
            ZStack{
                Rectangle()
                    .fill(.blue)
                    .frame(maxWidth: .infinity).frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text(book.name)
                
                
            }
        }
    }
}





struct CardView: View {
    var books: [Bok]
    
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(books.indices, id: \.self) { index in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 100, height: 150)
                            .cornerRadius(12)
                            .padding(.vertical,6)
                        Text(books[index].name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(y: index > 0 ? CGFloat(index) * 50 : 0)
                }
                
            }
        }
    }
}






#Preview {
    AdminSubCategoriesView(groupedBooks:
                            [ Bok(id: 1, isbn: "978-0-553-57340-4", name: "The Great Adventure", author: "Emily Smith", description: "A thrilling adventure novel filled with mystery and excitement.", publishingDate: "2023-05-15", category: "Fiction", subcategory: "Action", status: "Available"),
                              Bok(id: 2, isbn: "978-0-439-02348-6", name: "Secrets of the Lost City", author: "John Johnson", description: "An archaeological thriller uncovering the secrets of an ancient civilization.", publishingDate: "2022-09-20", category: "Fiction", subcategory: "Mystery", status: "Available"),
                              Bok(id: 3, isbn: "978-0-06-288180-3", name: "The Art of Cooking", author: "Linda Martinez", description: "A comprehensive guide to mastering the culinary arts.", publishingDate: "2023-02-10", category: "Non-Fiction", subcategory: "Cookbooks", status: "Available"),
                              Bok(id: 4, isbn: "978-0-306-40615-7", name: "The Universe Within", author: "David Thompson", description: "Exploring the mysteries of the cosmos and the human mind.", publishingDate: "2023-08-28", category: "Non-Fiction", subcategory: "Science", status: "Available"),
                              Bok(id: 5, isbn: "978-0-307-95614-7", name: "The Silent Observer", author: "Rachel Green", description: "A gripping psychological thriller that will keep you on the edge of your seat.", publishingDate: "2023-11-05", category: "Fiction", subcategory: "Thriller", status: "Available")
                            ])
}
