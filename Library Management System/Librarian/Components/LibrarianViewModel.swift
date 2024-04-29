import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseStorage

class LibrarianViewModel: ObservableObject{
    
    let dbInstance = Firestore.firestore()
    
    @Published var responseStatus = 0
    @Published var responseMessage = ""
    
    @Published var currentBook: [Book] = []
    @Published var allBooks: [Book] = []
    
    func addBook(bookISBN: String, bookName: String, bookAuthor: String, bookDescription: String, bookCategory: String, bookSubCategories: [String], bookPublishingDate: String, bookStatus: String, bookCount: Int, bookAvailableCount: Int, bookPreBookedCount: Int, bookTakenCount: Int, bookImage: UIImage){
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        let addNewBook = dbInstance.collection("Books").document()
        let storageRef = Storage.storage().reference()
        let imageData  = bookImage.jpegData(compressionQuality: 0.9)!
        let fileRef = storageRef.child("bookImages/\(addNewBook.documentID).jpeg")
        
        //var uploadDone  = false
        fileRef.putData(imageData, metadata: nil){
            metadata,error in
            
            if(error == nil && metadata != nil){
                fileRef.downloadURL{ url,error1 in
                    if(error1 == nil && url != nil){
                        let imageURL = url?.absoluteString
                        let newBook = Book(id: addNewBook.documentID, bookISBN: bookISBN, bookImageURL: imageURL!, bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookCategory: bookCategory, bookSubCategories: bookSubCategories, bookPublishingDate: bookPublishingDate, bookStatus: bookStatus, bookCount: bookCount, bookAvailableCount: bookAvailableCount, bookPreBookedCount: bookPreBookedCount, bookTakenCount: bookTakenCount, bookIssuedTo: [], bookIssuedToName: [], bookIssuedOn: [], bookExpectedReturnOn: [], bookRating: 0.0, bookReviews: [], bookHistory: [], createdOn: "\(Date.now)", updayedOn: "\(Date.now)")
                        addNewBook.setData(newBook.getDictionaryOfStruct()) { error in
                            
                            if let error = error{
                                self.responseStatus = 400
                                self.responseMessage = "Something went wrong, Unable to add book. Check console for errors."
                                print("Unable to add book. Error: \(error)")
                            }
                            else{
                                self.responseStatus = 200
                                self.responseMessage = "Added book successfuly."
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func updateBook(bookId: String, bookISBN: String, bookImageURL: String, bookName: String, bookAuthor: String, bookDescription: String, bookCategory: String, bookSubCategories: [String], bookPublishingDate: String, bookStatus: String, bookImage: UIImage, isImageUpdated: Bool, oldCount: Int, bookCount: Int, bookAvailableCount: Int){
        
        print(bookCount, oldCount, bookAvailableCount)
        
        var bookAvailable: Int = bookAvailableCount
        
        if(oldCount > bookCount){
            if(bookAvailable - (oldCount-bookCount) > 1){
                bookAvailable = bookAvailableCount - (oldCount-bookCount)
            }
            else{
                bookAvailable = 0
            }
        }
        else if(oldCount < bookCount){
            bookAvailable = bookAvailableCount + (bookCount-oldCount)
        }
        
        print(bookCount, oldCount, bookAvailable)
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        if(isImageUpdated){
            let storageRef = Storage.storage().reference()
            let imageData  = bookImage.jpegData(compressionQuality: 0.9)!
            let fileRef = storageRef.child("bookImages/\(bookId).jpeg")
            
            fileRef.putData(imageData, metadata: nil){
                metadata,error in
                
                if(error == nil && metadata != nil){
                    fileRef.downloadURL{ url,error1 in
                        if(error1 == nil && url != nil){
                            let imageURL = url?.absoluteString
                            self.dbInstance.collection("Books").document(bookId).updateData(["bookISBN":bookISBN,"bookName":bookName,"bookAuthor":bookAuthor,"bookStatus": bookStatus, "bookImageURL": imageURL as Any, "bookDescription": bookDescription, "bookCategory": bookCategory, "bookSubcategories": bookSubCategories, "bookCount": bookCount, "bookAvailableCount": bookAvailable, "updatedOn": Date.now.formatted()]) { error in
                                
                                if let error = error{
                                    self.responseStatus = 400
                                    self.responseMessage = "Something went wrong, Unable to update book. Check console for errors."
                                    print("Unable to update book. Error: \(error)")
                                }
                                else{
                                    self.responseStatus = 200
                                    self.responseMessage = "Updated book successfuly."
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        else{
            self.dbInstance.collection("Books").document(bookId).updateData(["bookISBN":bookISBN,"bookName":bookName,"bookAuthor":bookAuthor,"bookStatus": bookStatus, "bookImageURL": bookImageURL, "bookDescription": bookDescription, "bookCategory": bookCategory, "bookSubcategories": bookSubCategories, "bookCount": bookCount, "bookAvailableCount": bookAvailable, "updatedOn": Date.now.formatted()])  { error in
                
                if let error = error{
                    self.responseStatus = 400
                    self.responseMessage = "Something went wrong, Unable to update book. Check console for errors."
                    print("Unable to update book. Error: \(error)")
                }
                else{
                    self.responseStatus = 200
                    self.responseMessage = "Updated book successfuly."
                }
                
            }
        }
    }
    
    func deleteBook(bookId: String){
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        self.dbInstance.collection("Books").document(bookId).delete { error in
            if let error = error{
                self.responseStatus = 400
                self.responseMessage = "Something went wrong, Unable to delete book. Check console for errors."
                print("Unable to delete book. Error: \(error)")
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Deleted book successfuly."
            }
        }
    }
    
    func getBook(bookId: String){
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        self.dbInstance.collection("Books").document(bookId).getDocument { (document, error) in
            if error == nil{
                if (document != nil && document!.exists){
                    
                    guard let bookHistoryDictArray = document!["bookHistory"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }

                    var bookHistoryArray: [History] = []
                    for bookHistoryDict in bookHistoryDictArray {
                        guard let userId = bookHistoryDict["userId"] as? String,
                              let userName = bookHistoryDict["userName"] as? String,
                              let issuedOn = bookHistoryDict["issuedOn"] as? String,
                              let returnedOn = bookHistoryDict["returnedOn"] as? String
                        else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let bookHistory = History(userId: userId, userName: userName, issuedOn: issuedOn, returnedOn: returnedOn)
                        bookHistoryArray.append(bookHistory)
                    }

                    
                    self.currentBook = [ Book(id: document!["id"] as! String, bookISBN: document!["bookISBN"] as! String, bookImageURL: document!["bookImageURL"] as! String, bookName: document!["bookName"] as! String, bookAuthor: document!["bookAuthor"] as! String, bookDescription: document!["bookDescription"] as! String, bookCategory: document!["bookCategory"] as! String, bookSubCategories: document!["bookSubCategories"] as! [String], bookPublishingDate: document!["bookPublishingDate"] as! String, bookStatus: document!["bookStatus"] as! String, bookCount: document!["bookCount"] as! Int, bookAvailableCount:  document!["bookAvailableCount"] as! Int, bookPreBookedCount:  document!["bookPreBookedCount"] as! Int, bookTakenCount:  document!["bookTakenCount"] as! Int, bookIssuedTo: document!["bookIssuedTo"] as! [String], bookIssuedToName: document!["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: document!["bookIssuedOn"] as! [String], bookExpectedReturnOn: document!["bookExpectedReturnOn"] as! [String], bookRating: document!["bookRating"] as! Float, bookReviews: document!["bookReviews"] as! [String], bookHistory: bookHistoryArray, createdOn: document!["createdOn"] as! String, updayedOn: document!["updatedOn"] as! String) ]
                    self.responseStatus = 200
                    self.responseMessage = "Book fetched successfuly"
                }
                else{
                    self.responseStatus = 200
                    self.responseMessage = "Something went wrong, Unable to get book. Chek console for error"
                    print("Unable to get updated document. May be this could be the error: Book does not exist or db returned nil.")
                }
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Something went wrong, Unable to book. Chek console for error"
                print("Unable to get book. Error: \(String(describing: error)).")
            }
        }
    }
    
    func getBooks(){
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        dbInstance.collection("Books").getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                    
                    guard let bookHistoryDictArray = documentData["bookHistory"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }

                    var bookHistoryArray: [History] = []
                    for bookHistoryDict in bookHistoryDictArray {
                        guard let userId = bookHistoryDict["userId"] as? String,
                              let userName = bookHistoryDict["userName"] as? String,
                              let issuedOn = bookHistoryDict["issuedOn"] as? String,
                              let returnedOn = bookHistoryDict["returnedOn"] as? String
                        else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let bookHistory = History(userId: userId, userName: userName, issuedOn: issuedOn, returnedOn: returnedOn)
                        bookHistoryArray.append(bookHistory)
                    }
                    
                    let book = Book(id: documentData["id"] as! String as Any as! String, bookISBN: documentData["bookISBN"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookAuthor: documentData["bookAuthor"] as! String as Any as! String, bookDescription: documentData["bookDescription"] as! String as Any as! String, bookCategory: documentData["bookCategory"] as! String as Any as! String, bookSubCategories: documentData["bookSubCategories"] as! [String] as Any as! [String], bookPublishingDate: documentData["bookPublishingDate"] as! String as Any as! String, bookStatus: documentData["bookStatus"] as! String as Any as! String, bookCount: documentData["bookCount"] as! Int as Any as! Int, bookAvailableCount: documentData["bookAvailableCount"] as! Int as Any as! Int, bookPreBookedCount: documentData["bookPreBookedCount"] as! Int as Any as! Int, bookTakenCount: documentData["bookTakenCount"] as! Int as Any as! Int, bookIssuedTo: documentData["bookIssuedTo"] as! [String] as Any as! [String], bookIssuedToName: documentData["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: documentData["bookIssuedOn"] as! [String] as Any as! [String], bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! [String] as Any as! [String], bookRating: Float(documentData["bookRating"] as! Int as Any as! Int), bookReviews: documentData["bookReviews"] as! [String] as Any as! [String], bookHistory: bookHistoryArray, createdOn: documentData["createdOn"] as! String as Any as! String, updayedOn: documentData["updatedOn"] as! String as Any as! String)
                    if(self.allBooks.count == 0){
                        self.allBooks.append(book)
                    }
                    else{
                        for i in 0..<self.allBooks.count{
                            if(self.allBooks[i].id == book.id){
                                 break
                            }
                            else if(self.allBooks[i].id != book.id && i == self.allBooks.count-1){
                                self.allBooks.append(book)
                            }
                        }
                    }
                }
                print(self.allBooks)
            }
            
        }
        
    }
    
//    func filterBook(){
//
//        let allBooks = self.dbInstance.collection("Books")
//    }
    
}
