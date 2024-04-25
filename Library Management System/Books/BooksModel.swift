////
////  bookViewModel.swift
////  Library Management System
////
////  Created by admin on 24/04/24.
////
//
//
//
//import Foundation
//import Firebase
//
//
//enum bookStatus: String {
//    case booked = "Booked"
//    case available = "Available"
//    case reserved = "Reserved"
//}
//
//struct Book: Identifiable {
//    let id = UUID()
//    let bookID: Int // Auto generated
//    let bookISBN: String
//    let bookImage: String
//    let bookName: String
//    let bookAuthor: String
//    let bookDescription: String
//    let bookPublishingDate: Date
//    let bookCategory: [String]
//    let bookStatus: bookStatus
//    let issuedTo: String
//    let bookExpectedReturnOn: Date?
//    let history: [(String, Date, Date?)]
//    let bookRating: Int // Assuming it's a single rating
//    let bookReviews: [String]
//    let bookIssuedOn: Date?
//    let createdOn: Date
//    let updatedOn: Date
//}
//
////class BookViewModel: ObservableObject {
////    @Published var books: [Book] = []
////    private var db = Firestore.firestore()
////
////    // Add functions for data operations (fetching, updating, deleting)
////    // Example:
////    // func fetchBooks() { ... }
////    // func updateBook(_ book: Book) { ... }
////
////    func fetchBooks() {
////            db.collection("books").getDocuments { snapshot, error in
////                if let error = error {
////                    print("Error fetching documents: \(error)")
////                    return
////                }
////
////                guard let documents = snapshot?.documents else {
////                    print("No documents found")
////                    return
////                }
////
////                self.books = documents.compactMap { document in
////                    do {
////                        let data = try document.data(as: Book.self)
////                        return data
////                    } catch {
////                        print("Error decoding book data: \(error)")
////                        return nil
////                    }
////                }
////            }
////        }
////}
