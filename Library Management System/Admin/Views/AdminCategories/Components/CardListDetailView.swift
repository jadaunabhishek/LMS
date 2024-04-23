//
//  CardListDetailView.swift
//  Library Management System
//
//  Created by admin on 23/04/24.
//

import SwiftUI

struct CardListDetailView: View {
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

#Preview {
    CardListDetailView(books:
                        [ Bok(id: 1, isbn: "978-0-553-57340-4", name: "The Great Adventure", author: "Emily Smith", description: "A thrilling adventure novel filled with mystery and excitement.", publishingDate: "2023-05-15", category: "Fiction", subcategory: "Action", status: "Available"),
                          Bok(id: 2, isbn: "978-0-439-02348-6", name: "Secrets of the Lost City", author: "John Johnson", description: "An archaeological thriller uncovering the secrets of an ancient civilization.", publishingDate: "2022-09-20", category: "Fiction", subcategory: "Mystery", status: "Available"),
                          Bok(id: 3, isbn: "978-0-06-288180-3", name: "The Art of Cooking", author: "Linda Martinez", description: "A comprehensive guide to mastering the culinary arts.", publishingDate: "2023-02-10", category: "Non-Fiction", subcategory: "Cookbooks", status: "Available"),
                          Bok(id: 4, isbn: "978-0-306-40615-7", name: "The Universe Within", author: "David Thompson", description: "Exploring the mysteries of the cosmos and the human mind.", publishingDate: "2023-08-28", category: "Non-Fiction", subcategory: "Science", status: "Available"),
                          Bok(id: 5, isbn: "978-0-307-95614-7", name: "The Silent Observer", author: "Rachel Green", description: "A gripping psychological thriller that will keep you on the edge of your seat.", publishingDate: "2023-11-05", category: "Fiction", subcategory: "Thriller", status: "Available")
                        ])
}
