import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseStorage

class LibrarianViewModel: ObservableObject{
    
    let dbInstance = Firestore.firestore()
    
    @Published var responseStatus = 0
    @Published var responseMessage = ""
    
    @Published var currentBook: [Book] = []
    
    func addBook(bookISBN: String, bookName: String, bookAuthor: String, bookDescription: String, bookCategory: [String], bookPublishingDate: String, bookStatus: String, bookImage: UIImage){
        
        let addNewBook = dbInstance.collection("Books").document()
        let storageRef = Storage.storage().reference()
        let imageData  = bookImage.jpegData(compressionQuality: 0.9)!
        let fileRef = storageRef.child("bookImages/\(addNewBook.documentID).jpeg")
        
        var uploadDone  = false
        fileRef.putData(imageData, metadata: nil){
            metadata,error in
            
            if(error == nil && metadata != nil){
                fileRef.downloadURL{ url,error1 in
                    if(error1 == nil && url != nil){
                        var imageURL = url?.absoluteString
                        let newBook = Book(id: addNewBook.documentID, bookISBN: bookISBN, bookImageURL: imageURL!, bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookCategory: bookCategory, bookPublishingDate: bookPublishingDate, bookStatus: bookStatus, bookIssuedTo: "", bookIssuedOn: "", bookExpectedReturnOn: "", bookRating: 0.0, bookReviews: [], bookHistory: [], createdOn: "\(Date.now)", updayedOn: "\(Date.now)")
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
    
    func updateBook(bookId: String, bookISBN: String, bookImageURL: String, bookName: String, bookAuthor: String, bookDescription: String, bookCategory: [String], bookPublishingDate: String, bookStatus: String, bookImage: UIImage, isImageUpdated: Bool){
        
        if(isImageUpdated){
            let storageRef = Storage.storage().reference()
            let imageData  = bookImage.jpegData(compressionQuality: 0.9)!
            let fileRef = storageRef.child("bookImages/\(bookId).jpeg")
            
            var uploadDone  = false
            fileRef.putData(imageData, metadata: nil){
                metadata,error in
                
                if(error == nil && metadata != nil){
                    fileRef.downloadURL{ url,error1 in
                        if(error1 == nil && url != nil){
                            var imageURL = url?.absoluteString
                            let newBook = Book(id: bookId, bookISBN: bookISBN, bookImageURL: imageURL!, bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookCategory: bookCategory, bookPublishingDate: bookPublishingDate, bookStatus: bookStatus, bookIssuedTo: "", bookIssuedOn: "", bookExpectedReturnOn: "", bookRating: 0.0, bookReviews: [], bookHistory: [], createdOn: "\(Date.now)", updayedOn: "\(Date.now)")
                            self.dbInstance.collection("Books").document(bookId).setData(newBook.getDictionaryOfStruct()) { error in
                                
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
            let newBook = Book(id: bookId, bookISBN: bookISBN, bookImageURL: bookImageURL, bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookCategory: bookCategory, bookPublishingDate: bookPublishingDate, bookStatus: bookStatus, bookIssuedTo: "", bookIssuedOn: "", bookExpectedReturnOn: "", bookRating: 0.0, bookReviews: [], bookHistory: [], createdOn: "\(Date.now)", updayedOn: "\(Date.now)")
            self.dbInstance.collection("Books").document(bookId).setData(newBook.getDictionaryOfStruct()) { error in
                
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
    
    func getBook(bookId: String){
        
        self.dbInstance.collection("Books").document(bookId).getDocument { (document, error) in
            if error == nil{
                if (document != nil && document!.exists){
                    self.currentBook = [ Book(id: document!["id"] as! String, bookISBN: document!["bookISBN"] as! String, bookImageURL: document!["bookImageURL"] as! String, bookName: document!["bookName"] as! String, bookAuthor: document!["bookAuthor"] as! String, bookDescription: document!["bookDescription"] as! String, bookCategory: document!["bookCategory"] as! [String], bookPublishingDate: document!["bookPublishingDate"] as! String, bookStatus: document!["bookStatus"] as! String, bookIssuedTo: document!["bookIssuedTo"] as! String, bookIssuedOn: document!["bookIssuedOn"] as! String, bookExpectedReturnOn: document!["bookExpectedReturnOn"] as! String, bookRating: document!["bookRating"] as! Float, bookReviews: document!["bookReviews"] as! [String], bookHistory: document!["bookHistory"] as! [History], createdOn: document!["createdOn"] as! String, updayedOn: document!["updatedOn"] as! String) ]
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
    
//    func filterBook(){
//        
//        let allBooks = self.dbInstance.collection("Books")
//    }
    
}
