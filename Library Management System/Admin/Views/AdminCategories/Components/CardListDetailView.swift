//
//  CardListDetailView.swift
//  Library Management System
//
//  Created by admin on 23/04/24.
//

import SwiftUI

struct CardListDetailView: View {
    var books: [Book]
    var body: some View {
        //        ForEach(books) { book in
        //            HStack {
        //                // Book cover image
        //                Image(systemName: "book.fill") // Placeholder image
        //                    .resizable()
        //                    .aspectRatio(contentMode: .fit)
        //                    .frame(width: 100, height: 100) // Adjust size as needed
        //                    .foregroundColor(.white)
        //                    .padding()// Placeholder color
        //                Spacer()
        //                // VStack for book details
        //                VStack(alignment: .leading) {
        //                    // Book name
        //                    Text(book.bookName)
        //                        .font(.headline)
        //                    
        //                    // Book author
        //                    Text("By \(book.bookAuthor)")
        //                        .font(.subheadline)
        //                        .foregroundColor(.secondary)
        //                }
        //                .padding(.leading, 8) // Add padding between image and text
        //                .padding(.trailing, 16) // Add trailing padding to align with the screen edge
        //            }
        //            .frame(maxWidth: .infinity) // Expand to the entire screen width
        //            .frame(height: 100) // Fixed height for the card
        //            .background(Color.black.opacity(0.2)) // Background color for the card
        //            .cornerRadius(10) // Apply corner radius for rounded corners
        //            .padding(8) // Add padding around the card
        //        }
        //    }
        Text("gi")
    }
}

#Preview {
    CardListDetailView(books:
                        [])
}
