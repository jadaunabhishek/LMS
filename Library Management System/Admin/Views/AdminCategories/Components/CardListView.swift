//
//  CardListView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct CardListView: View {
    
    @State var books: [Book]
    
    @State var isImageSelected: Bool = false
    @State var openPhotoPicker: Bool = false
    var body: some View {
        
        ScrollView(.horizontal){
            HStack{
                ForEach(books.indices, id: \.self) { index in
                    VStack(alignment: .center,spacing: 0) {
                        AsyncImage(url: URL(string: books[index].bookImageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(8)
                            case .failure(_):
                                Image(systemName: "text.book.closed")
                                    .resizable()
                                    .frame(width: 120, height: 180)
                            case .empty:
                                ZStack{
                                    Image(systemName: "text.book.closed")
                                        .resizable()
                                        .opacity(0.6)
                                        
                                    ProgressView()
                                }.frame(width: 120, height: 180)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        Text(books[index].bookName)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

#Preview {
    CardListView(books: [Book(
        id: "1",
        bookISBN: "1234567890",
        bookImageURL: "https://firebasestorage.googleapis.com:443/v0/b/library-management-syste-6cc1e.appspot.com/o/bookImages%2FqwANOlS3VLxsyvBt6vZz.jpeg?alt=media&token=68b371ed-d821-41b4-a80f-1d52e6426676",
        bookName: "Fake Book",
        bookAuthor: "John Doe",
        bookDescription: "A fake book for testing purposes",
        bookCategory: "Fiction",
        bookSubCategories: ["Thriller", "Mystery"],
        bookPublishingDate: "2023-01-01",
        bookStatus: "Available",
        bookIssuedTo: "",
        bookIssuedToName: "",
        bookIssuedOn: "",
        bookExpectedReturnOn: "",
        bookRating: 4.5,
        bookReviews: ["Great book!", "Highly recommended!"],
        bookHistory: [],
        createdOn: "2023-01-01",
        updayedOn: "2023-01-01"
    )])
}


struct CardView: View {
    var books: [Book]
    
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
                        Text(books[index].bookName)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
        }
    }
}

