import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseStorage

class LibrarianViewModel: ObservableObject{
    
    let dbInstance = Firestore.firestore()
    
    @Published var responseStatus = 0
    @Published var responseMessage = ""
    
    @Published var currentStaff: [Staff] = []
    @Published var currentConfig: [Config] = []
    @Published var currentMember: [UserSchema] = []
    @Published var currentBook: [Book] = []
    @Published var currentBookHistory: [Loan] = []
    @Published var currentUserHistory: [Loan] = []
    @Published var currentUserOverDueHistory: [Loan] = []
    @Published var currentUserProperHistory: [Loan] = []
    @Published var allBooks: [Book] = []
    @Published var topRatedBooks: [Book] = []
    @Published var trendingBooks: [Book] = []
    @Published var requestedLoans: [Loan] = []
    @Published var issuedLoans: [Loan] = []
    @Published var activeLoans: [Loan] = []
    @Published var overDueLoans: [Loan] = []
    @Published var returnedLoans: [Loan] = []
    @Published var preBookedLoans: [Loan] = []
    @Published var allLoans: [Loan] = []
    @Published var categoryStat: [categoryStats] = []
    
    func addBook(bookISBN: String, bookName: String, bookAuthor: String, bookDescription: String, bookCategory: String, bookSubCategories: [String], bookPublishingDate: String, bookStatus: String, bookCount: Int, bookAvailableCount: Int, bookPreBookedCount: Int, bookTakenCount: Int, bookImage: UIImage){
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        let addNewBook = dbInstance.collection("Books").document()
        let storageRef = Storage.storage().reference()
        let imageData  = bookImage.jpegData(compressionQuality: 0.1)!
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
            let imageData  = bookImage.jpegData(compressionQuality: 0.1)!
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
        
        //        self.responseStatus = 0
        //        self.responseMessage = ""
        
        var tempBooks: [Book] = []
        
        dbInstance.collection("Books").order(by: "bookName").getDocuments{ (snapshot, error) in
            
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
                    
                    let book = Book(id: documentData["id"] as! String as Any as! String, bookISBN: documentData["bookISBN"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookAuthor: documentData["bookAuthor"] as! String as Any as! String, bookDescription: documentData["bookDescription"] as! String as Any as! String, bookCategory: documentData["bookCategory"] as! String as Any as! String, bookSubCategories: documentData["bookSubCategories"] as! [String] as Any as! [String], bookPublishingDate: documentData["bookPublishingDate"] as! String as Any as! String, bookStatus: documentData["bookStatus"] as! String as Any as! String, bookCount: documentData["bookCount"] as! Int as Any as! Int, bookAvailableCount: documentData["bookAvailableCount"] as! Int as Any as! Int, bookPreBookedCount: documentData["bookPreBookedCount"] as! Int as Any as! Int, bookTakenCount: documentData["bookTakenCount"] as! Int as Any as! Int, bookIssuedTo: documentData["bookIssuedTo"] as! [String] as Any as! [String], bookIssuedToName: documentData["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: documentData["bookIssuedOn"] as! [String] as Any as! [String], bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! [String] as Any as! [String], bookRating: Float(documentData["bookRating"] as! Float as Any as! Float), bookReviews: documentData["bookReviews"] as! [String] as Any as! [String], bookHistory: bookHistoryArray, createdOn: documentData["createdOn"] as! String as Any as! String, updayedOn: documentData["updatedOn"] as! String as Any as! String)
                    tempBooks.append(book)
                }
                self.allBooks = tempBooks
            }
            
        }
        
    }
    
    func getTopRatedBooks(){
        
        var tempBooks: [Book] = []
        
        dbInstance.collection("Books").order(by: "bookRating").getDocuments{ (snapshot, error) in
            
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
                    
                    let book = Book(id: documentData["id"] as! String as Any as! String, bookISBN: documentData["bookISBN"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookAuthor: documentData["bookAuthor"] as! String as Any as! String, bookDescription: documentData["bookDescription"] as! String as Any as! String, bookCategory: documentData["bookCategory"] as! String as Any as! String, bookSubCategories: documentData["bookSubCategories"] as! [String] as Any as! [String], bookPublishingDate: documentData["bookPublishingDate"] as! String as Any as! String, bookStatus: documentData["bookStatus"] as! String as Any as! String, bookCount: documentData["bookCount"] as! Int as Any as! Int, bookAvailableCount: documentData["bookAvailableCount"] as! Int as Any as! Int, bookPreBookedCount: documentData["bookPreBookedCount"] as! Int as Any as! Int, bookTakenCount: documentData["bookTakenCount"] as! Int as Any as! Int, bookIssuedTo: documentData["bookIssuedTo"] as! [String] as Any as! [String], bookIssuedToName: documentData["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: documentData["bookIssuedOn"] as! [String] as Any as! [String], bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! [String] as Any as! [String], bookRating: Float(documentData["bookRating"] as! Float as Any as! Float), bookReviews: documentData["bookReviews"] as! [String] as Any as! [String], bookHistory: bookHistoryArray, createdOn: documentData["createdOn"] as! String as Any as! String, updayedOn: documentData["updatedOn"] as! String as Any as! String)
                    tempBooks.append(book)
                }
                self.topRatedBooks = tempBooks
            }
            
        }
        
    }
    
    func getTrendingBooks(){
        
        var tempBooks: [Book] = []
        
        dbInstance.collection("Books").order(by: "bookPreBookedCount").getDocuments{ (snapshot, error) in
            
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
                    
                    let book = Book(id: documentData["id"] as! String as Any as! String, bookISBN: documentData["bookISBN"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookAuthor: documentData["bookAuthor"] as! String as Any as! String, bookDescription: documentData["bookDescription"] as! String as Any as! String, bookCategory: documentData["bookCategory"] as! String as Any as! String, bookSubCategories: documentData["bookSubCategories"] as! [String] as Any as! [String], bookPublishingDate: documentData["bookPublishingDate"] as! String as Any as! String, bookStatus: documentData["bookStatus"] as! String as Any as! String, bookCount: documentData["bookCount"] as! Int as Any as! Int, bookAvailableCount: documentData["bookAvailableCount"] as! Int as Any as! Int, bookPreBookedCount: documentData["bookPreBookedCount"] as! Int as Any as! Int, bookTakenCount: documentData["bookTakenCount"] as! Int as Any as! Int, bookIssuedTo: documentData["bookIssuedTo"] as! [String] as Any as! [String], bookIssuedToName: documentData["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: documentData["bookIssuedOn"] as! [String] as Any as! [String], bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! [String] as Any as! [String], bookRating: Float(documentData["bookRating"] as! Float as Any as! Float), bookReviews: documentData["bookReviews"] as! [String] as Any as! [String], bookHistory: bookHistoryArray, createdOn: documentData["createdOn"] as! String as Any as! String, updayedOn: documentData["updatedOn"] as! String as Any as! String)
                    tempBooks.append(book)
                }
                self.trendingBooks = tempBooks
            }
            
        }
        
    }
    
    func checkOutBook(loanId:String){
        
        self.dbInstance.collection("Loans").document(loanId).updateData(["loanStatus":"Issued", "updatedOn": Date.now.formatted()]){ error in
            if let error = error{
                self.responseStatus = 400
                self.responseMessage = "Something went wrong, Unable to complete loan. Check console for errors."
                print("Unable to update loan. Error: \(error)")
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Updated loan successfuly."
            }
        }
        
    }
    
    func checkInBook(loanId: String, bookId:String, userId: String, userFines: Int, loanFine: Int, userPenalty: Int) async{
        
        
        var currenBook: [Book] = []
        var preBookings: [Loan] = []
        
        self.dbInstance.collection("Loans").document(loanId).updateData(["loanStatus":"Returned"]){ error in
            if let error = error{
                print("Loan updateion Error")
            }
            else{
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
                            
                            
                            currenBook = [ Book(id: document!["id"] as! String, bookISBN: document!["bookISBN"] as! String, bookImageURL: document!["bookImageURL"] as! String, bookName: document!["bookName"] as! String, bookAuthor: document!["bookAuthor"] as! String, bookDescription: document!["bookDescription"] as! String, bookCategory: document!["bookCategory"] as! String, bookSubCategories: document!["bookSubCategories"] as! [String], bookPublishingDate: document!["bookPublishingDate"] as! String, bookStatus: document!["bookStatus"] as! String, bookCount: document!["bookCount"] as! Int, bookAvailableCount:  document!["bookAvailableCount"] as! Int, bookPreBookedCount:  document!["bookPreBookedCount"] as! Int, bookTakenCount:  document!["bookTakenCount"] as! Int, bookIssuedTo: document!["bookIssuedTo"] as! [String], bookIssuedToName: document!["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: document!["bookIssuedOn"] as! [String], bookExpectedReturnOn: document!["bookExpectedReturnOn"] as! [String], bookRating: document!["bookRating"] as! Float, bookReviews: document!["bookReviews"] as! [String], bookHistory: bookHistoryArray, createdOn: document!["createdOn"] as! String, updayedOn: document!["updatedOn"] as! String) ]
                            if(currenBook[0].bookPreBookedCount > 0){
                                self.dbInstance.collection("Loans").order(by: "timeStamp", descending: false).getDocuments{ (snapshot, error) in
                                    if(error == nil && snapshot != nil){
                                        for document in snapshot!.documents{
                                            let documentData = document.data()
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "dd/MM/yy"
                                            
                                            let tempLoan = Loan(loanId: documentData["loanId"] as! String as Any as! String, bookId: documentData["bookId"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookReturnedOn: documentData["bookReturnedOn"] as! String as Any as! String, loanStatus: documentData["loanStatus"] as! String as Any as! String, loanReminderStatus: documentData["loanReminderStatus"] as! String as Any as! String, fineCalculatedDays: documentData["fineCalculatedDays"] as! Int as Any as! Int, loanFine: documentData["loanFine"] as! Int as Any as! Int, createdOn:  documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, timeStamp: documentData["timeStamp"] as! Int as Any as! Int)
                                            if(tempLoan.bookId == bookId && tempLoan.loanStatus == "PreBooked"){
                                                preBookings.append(tempLoan)
                                            }
                                        }
                                        self.dbInstance.collection("Books").document(bookId).updateData(["bookPreBookedCount": currenBook[0].bookPreBookedCount-1, "updatedOn":Date.now.formatted()]){ error in
                                            if let error = error{
                                                print("Unable to update book")
                                            }
                                            else{
                                                self.dbInstance.collection("Loans").document(preBookings[0].loanId).updateData(["loanStatus":"Requested"]){ error in
                                                    if let error = error{
                                                        print("Loan updateion Error")
                                                    }
                                                    else{
                                                        self.dbInstance.collection("users").document(userId).updateData(["activeFine": userFines+loanFine, "penaltiesCount": userPenalty+1]){ error in
                                                            if let error = error{
                                                                self.responseStatus = 400
                                                            }
                                                            else{
                                                                self.responseStatus = 200
                                                                self.responseMessage = "Completed loan successfuly."
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                //preBookings = preBookings.sorted(by: {$0.timeStamp < $1.timeStamp})
                            }
                            else{
                                self.dbInstance.collection("Books").document(bookId).updateData(["bookStatus":"Available", "bookAvailableCount": currenBook[0].bookAvailableCount+1, "bookTakenCount": currenBook[0].bookTakenCount-1, "updatedOn":Date.now.formatted()]){ error in
                                    
                                    if let error = error{
                                        self.responseStatus = 400
                                        self.responseMessage = "Something went wrong, Unable to update book. Check console for errors."
                                        print("Unable to update book. Error: \(error)")
                                    }
                                    else{
                                        self.dbInstance.collection("Loans").document(loanId).updateData(["bookReturnedOn":Date.now.formatted(), "loanStatus": "Returned", "updatedOn": Date.now.formatted()]){ error in
                                            if let error = error{
                                                self.responseStatus = 400
                                                self.responseMessage = "Something went wrong, Unable to complete loan. Check console for errors."
                                                print("Unable to update loan. Error: \(error)")
                                            }
                                            else{
                                                self.dbInstance.collection("users").document(userId).updateData(["activeFine": userFines+loanFine, "penaltiesCount": userPenalty+1]){ error in
                                                    if let error = error{
                                                        self.responseStatus = 400
                                                    }
                                                    else{
                                                        self.dbInstance.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").getDocument{ (document,error) in
                                                            if error == nil{
                                                                if (document != nil && document!.exists){
                                                                    guard let fineDetailsDictArray = document!["fineDetails"] as? [[String: Any]] else {
                                                                        print("Error: Unable to parse fineDetails array from Firestore document")
                                                                        return
                                                                    }

                                                                    var fineDetailsArray: [fineDetails] = []
                                                                    for fineDetailDict in fineDetailsDictArray {
                                                                        guard let fine = fineDetailDict["fine"] as? Int,
                                                                              let period = fineDetailDict["period"] as? Int else {
                                                                            print("Error: Unable to parse fineDetail from dictionary")
                                                                            continue
                                                                        }
                                                                        
                                                                        let fineDetail = fineDetails(fine: fine, period: period)
                                                                        fineDetailsArray.append(fineDetail)
                                                                        
                                                                    }
                                                                    
                                                                    guard let monthlyMembersCountDictArray = document!["monthlyMembersCount"] as? [[String: Any]] else {
                                                                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                                                                        return
                                                                    }

                                                                    var monthlyMembersCountArray: [membersCount] = []
                                                                    for memberCountDict in monthlyMembersCountDictArray {
                                                                        guard let month = memberCountDict["month"] as? String,
                                                                              let count = memberCountDict["count"] as? Int else {
                                                                            print("Error: Unable to parse memberCount from dictionary")
                                                                            continue
                                                                        }
                                                                        
                                                                        let memberCount = membersCount(month: month, count: count)
                                                                        monthlyMembersCountArray.append(memberCount)
                                                                    }

                                                                    
                                                                    guard let monthlyIncomeDictArray = document!["monthlyIncome"] as? [[String: Any]] else {
                                                                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                                                                        return
                                                                    }
                                                                    
                                                                    var monthlyIncomeArray: [monthlyIncome] = []
                                                                    for memberIncomeDict in monthlyIncomeDictArray {
                                                                        guard let month = memberIncomeDict["month"] as? String,
                                                                              let count = memberIncomeDict["income"] as? Int else {
                                                                            print("Error: Unable to parse memberCount from dictionary")
                                                                            continue
                                                                        }
                                                                        
                                                                        let monthlyIncome = monthlyIncome(month: month, income: count)
                                                                        monthlyIncomeArray.append(monthlyIncome)
                                                                    }

                                                                    
                                                                    var newConfig = Config(
                                                                        configID: document!["configID"] as! String,
                                                                        adminID: document!["adminID"] as! String,
                                                                        logo: document!["logo"] as! String,
                                                                        accentColor: document!["accentColor"] as! String,
                                                                        loanPeriod: document!["loanPeriod"] as! Int,
                                                                        fineDetails: fineDetailsArray,
                                                                        maxFine: document!["maxFine"] as! Double,
                                                                        maxPenalties: document!["maxPenalties"] as! Int,
                                                                        categories: document!["categories"] as! [String],
                                                                        monthlyMembersCount: monthlyMembersCountArray, monthlyIncome: monthlyIncomeArray)
                                                                    
                                                                    if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
                                                                        let monthStr = Calendar.current.monthSymbols[monthInt-1]
                                                                        
                                                                        for i in 0..<newConfig.monthlyIncome.count{
                                                                            if(newConfig.monthlyIncome[i].month == monthStr){
                                                                                newConfig.monthlyIncome[i].income += loanFine
                                                                            }
                                                                        }
                                                                        self.dbInstance.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").setData(newConfig.getDictionaryOfStruct()){ error in
                                                                            if let error = error{
                                                                                print(error)
                                                                            }
                                                                            else{
                                                                                print("Done")
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            self.responseStatus = 400
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
        }
    }
    
    func rejectRequest(loanId: String, bookId:String) async{
        
        
        var currenBook: [Book] = []
        var preBookings: [Loan] = []
        
        self.dbInstance.collection("Loans").document(loanId).updateData(["loanStatus":"Rejected"]){ error in
            if let error = error{
                print("Loan updateion Error")
            }
            else{
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
                            
                            
                            currenBook = [ Book(id: document!["id"] as! String, bookISBN: document!["bookISBN"] as! String, bookImageURL: document!["bookImageURL"] as! String, bookName: document!["bookName"] as! String, bookAuthor: document!["bookAuthor"] as! String, bookDescription: document!["bookDescription"] as! String, bookCategory: document!["bookCategory"] as! String, bookSubCategories: document!["bookSubCategories"] as! [String], bookPublishingDate: document!["bookPublishingDate"] as! String, bookStatus: document!["bookStatus"] as! String, bookCount: document!["bookCount"] as! Int, bookAvailableCount:  document!["bookAvailableCount"] as! Int, bookPreBookedCount:  document!["bookPreBookedCount"] as! Int, bookTakenCount:  document!["bookTakenCount"] as! Int, bookIssuedTo: document!["bookIssuedTo"] as! [String], bookIssuedToName: document!["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: document!["bookIssuedOn"] as! [String], bookExpectedReturnOn: document!["bookExpectedReturnOn"] as! [String], bookRating: document!["bookRating"] as! Float, bookReviews: document!["bookReviews"] as! [String], bookHistory: bookHistoryArray, createdOn: document!["createdOn"] as! String, updayedOn: document!["updatedOn"] as! String) ]
                            if(currenBook[0].bookPreBookedCount > 0){
                                self.dbInstance.collection("Loans").order(by: "timeStamp", descending: false).getDocuments{ (snapshot, error) in
                                    if(error == nil && snapshot != nil){
                                        for document in snapshot!.documents{
                                            let documentData = document.data()
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "dd/MM/yy"
                                            
                                            let tempLoan = Loan(loanId: documentData["loanId"] as! String as Any as! String, bookId: documentData["bookId"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookReturnedOn: documentData["bookReturnedOn"] as! String as Any as! String, loanStatus: documentData["loanStatus"] as! String as Any as! String, loanReminderStatus: documentData["loanReminderStatus"] as! String as Any as! String, fineCalculatedDays: documentData["fineCalculatedDays"] as! Int as Any as! Int, loanFine:  documentData["loanFine"] as! Int as Any as! Int, createdOn:  documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, timeStamp: documentData["timeStamp"] as! Int as Any as! Int)
                                            if(tempLoan.bookId == bookId && tempLoan.loanStatus == "PreBooked"){
                                                preBookings.append(tempLoan)
                                            }
                                        }
                                        self.dbInstance.collection("Books").document(bookId).updateData(["bookPreBookedCount": currenBook[0].bookPreBookedCount-1, "updatedOn":Date.now.formatted()]){ error in
                                            if let error = error{
                                                print("Unable to update book")
                                            }
                                            else{
                                                self.dbInstance.collection("Loans").document(preBookings[0].loanId).updateData(["loanStatus":"Requested"]){ error in
                                                    if let error = error{
                                                        print("Loan updateion Error")
                                                    }
                                                    else{
                                                        print("Updated loan successfully")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                //preBookings = preBookings.sorted(by: {$0.timeStamp < $1.timeStamp})
                            }
                            else{
                                self.dbInstance.collection("Books").document(bookId).updateData(["bookStatus":"Available", "bookAvailableCount": currenBook[0].bookAvailableCount+1, "bookTakenCount": currenBook[0].bookTakenCount-1, "updatedOn":Date.now.formatted()]){ error in
                                    
                                    if let error = error{
                                        self.responseStatus = 400
                                        self.responseMessage = "Something went wrong, Unable to update book. Check console for errors."
                                        print("Unable to update book. Error: \(error)")
                                    }
                                    else{
                                        self.dbInstance.collection("Loans").document(loanId).updateData(["bookReturnedOn":Date.now.formatted(), "loanStatus": "Rejected", "updatedOn": Date.now.formatted()]){ error in
                                            if let error = error{
                                                self.responseStatus = 400
                                                self.responseMessage = "Something went wrong, Unable to complete loan. Check console for errors."
                                                print("Unable to update loan. Error: \(error)")
                                            }
                                            else{
                                                self.responseStatus = 200
                                                self.responseMessage = "Completed loan successfuly."
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            self.responseStatus = 400
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
        }
    }
    
    
    func getLoans(){
        
        var tempRequestedLoans: [Loan] = []
        var tempIssuedLoans: [Loan] = []
        var tempPreBookedLoans: [Loan] = []
        var tempActiveLoans: [Loan] = []
        var tempOverDueLoans: [Loan] = []
        var tempReturnedLoans: [Loan] = []
        var tempAllLoans: [Loan] = []
        
        self.dbInstance.collection("Loans").order(by: "timeStamp", descending: true).getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                    
                    let tempLoan = Loan(loanId: documentData["loanId"] as! String as Any as! String, bookId: documentData["bookId"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookReturnedOn: documentData["bookReturnedOn"] as! String as Any as! String, loanStatus: documentData["loanStatus"] as! String as Any as! String, loanReminderStatus: documentData["loanReminderStatus"] as! String as Any as! String, fineCalculatedDays: documentData["fineCalculatedDays"] as! Int as Any as! Int, loanFine: documentData["loanFine"] as! Int as Any as! Int, createdOn: documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, timeStamp: documentData["timeStamp"] as! Int as Any as! Int)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yy"
                    
                    tempAllLoans.append(tempLoan)
                    
                    if(tempLoan.loanStatus == "Issued"){
                        let date = dateFormatter.date(from:String(tempLoan.bookExpectedReturnOn.split(separator: ",")[0]))!
                        tempIssuedLoans.append(tempLoan)
                        if(date < Date.now){
                            tempOverDueLoans.append(tempLoan)
                        }
                        else{
                            tempActiveLoans.append(tempLoan)
                        }
                    }
                    else if(tempLoan.loanStatus == "Requested"){
                        tempRequestedLoans.append(tempLoan)
                    }
                    else if(tempLoan.loanStatus == "PreBooked"){
                        tempPreBookedLoans.append(tempLoan)
                    }
                    else{
                        tempReturnedLoans.append(tempLoan)
                    }
                    
                }
                
                self.issuedLoans = tempIssuedLoans
                self.requestedLoans = tempRequestedLoans
                self.activeLoans = tempActiveLoans
                self.overDueLoans = tempOverDueLoans
                self.returnedLoans = tempReturnedLoans
                self.preBookedLoans = tempPreBookedLoans
                self.allLoans = tempAllLoans
                
            }
        }
    }
    
    func getBookHistory(bookId: String){
        
        var tempBookHistory: [Loan] = []
        
        self.dbInstance.collection("Loans").getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                    
                    let tempLoan = Loan(loanId: documentData["loanId"] as! String as Any as! String, bookId: documentData["bookId"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookReturnedOn: documentData["bookReturnedOn"] as! String as Any as! String, loanStatus: documentData["loanStatus"] as! String as Any as! String, loanReminderStatus: documentData["loanReminderStatus"] as! String as Any as! String, fineCalculatedDays: documentData["fineCalculatedDays"] as! Int as Any as! Int, loanFine: documentData["loanFine"] as! Int as Any as! Int, createdOn: documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, timeStamp: documentData["timeStamp"] as! Int as Any as! Int)
                    
                    if(tempLoan.bookId == bookId){
                        tempBookHistory.append(tempLoan)
                    }
                    
                }
                
                self.currentBookHistory = tempBookHistory
                
            }
        }
    }
    
    func getUserHistory(userId: String){
        
        var tempUserHistory: [Loan] = []
        var tempUserOverDueHistory: [Loan] = []
        var tempUserProperHistory: [Loan] = []
        
        self.dbInstance.collection("Loans").getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                    
                    let tempLoan = Loan(loanId: documentData["loanId"] as! String as Any as! String, bookId: documentData["bookId"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookReturnedOn: documentData["bookReturnedOn"] as! String as Any as! String, loanStatus: documentData["loanStatus"] as! String as Any as! String, loanReminderStatus: documentData["loanReminderStatus"] as! String as Any as! String, fineCalculatedDays: documentData["fineCalculatedDays"] as! Int as Any as! Int, loanFine: documentData["loanFine"] as! Int as Any as! Int, createdOn: documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, timeStamp: documentData["timeStamp"] as! Int as Any as! Int)
                    
                    if(tempLoan.bookIssuedTo == userId){
                        tempUserHistory.append(tempLoan)
                        if(tempLoan.fineCalculatedDays > 0){
                            tempUserOverDueHistory.append(tempLoan)
                        }
                        else{
                            tempUserProperHistory.append(tempLoan)
                        }
                    }
                    
                }
                self.currentUserHistory = tempUserHistory
                self.currentUserProperHistory = tempUserProperHistory
                self.currentUserOverDueHistory = tempUserOverDueHistory
                
            }
        }
    }
    
    func updateLoanReminderStatus(loanId: String){
        
        self.dbInstance.collection("Loans").document(loanId).updateData(["loanReminderStatus": "Set", "updatedOn": Date.now.formatted()]){ error in
            if let error = error{
                self.responseStatus = 400
                self.responseMessage = "Something went wrong, Unable to complete loan. Check console for errors."
                print("Unable to update book. Error: \(error)")
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Completed loan successfuly."
            }
        }

    }
    
    func calculateFine(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        self.dbInstance.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").getDocument { document, error in
            if error == nil {
                if document != nil && document!.exists {
                    
                    guard let fineDetailsDictArray = document!["fineDetails"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }
                    
                    var fineDetailsArray: [fineDetails] = []
                    for fineDetailDict in fineDetailsDictArray {
                        guard let fine = fineDetailDict["fine"] as? Int,
                              let period = fineDetailDict["period"] as? Int else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let fineDetail = fineDetails(fine: fine, period: period)
                        fineDetailsArray.append(fineDetail)
                    }
                    
                    guard let monthlyMembersCountDictArray = document!["monthlyMembersCount"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                        return
                    }

                    var monthlyMembersCountArray: [membersCount] = []
                    for memberCountDict in monthlyMembersCountDictArray {
                        guard let month = memberCountDict["month"] as? String,
                              let count = memberCountDict["count"] as? Int else {
                            print("Error: Unable to parse memberCount from dictionary")
                            continue
                        }
                        
                        let memberCount = membersCount(month: month, count: count)
                        monthlyMembersCountArray.append(memberCount)
                    }
                    
                    guard let monthlyIncomeDictArray = document!["monthlyIncome"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                        return
                    }
                    
                    var monthlyIncomeArray: [monthlyIncome] = []
                    for memberIncomeDict in monthlyIncomeDictArray {
                        guard let month = memberIncomeDict["month"] as? String,
                              let count = memberIncomeDict["income"] as? Int else {
                            print("Error: Unable to parse memberCount from dictionary")
                            continue
                        }
                        
                        let monthlyIncome = monthlyIncome(month: month, income: count)
                        monthlyIncomeArray.append(monthlyIncome)
                    }

                    guard let monthlyRevenueTotalDictArray = document!["monthlyRevenueTotal"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyRevenueTotal array from Firestore document")
                        return
                    }
                    
                    var newConfig = Config(
                        configID: document!["configID"] as! String,
                        adminID: document!["adminID"] as! String,
                        logo: document!["logo"] as! String,
                        accentColor: document!["accentColor"] as! String,
                        loanPeriod: document!["loanPeriod"] as! Int,
                        fineDetails: fineDetailsArray,
                        maxFine: document!["maxFine"] as! Double,
                        maxPenalties: document!["maxPenalties"] as! Int,
                        categories: document!["categories"] as! [String],
                        monthlyMembersCount: monthlyMembersCountArray, monthlyIncome: monthlyIncomeArray)
                    
                    self.dbInstance.collection("Loans").whereField("loanStatus", isEqualTo: "Issued").getDocuments{
                        
                        (snapshot, error) in
                        
                        if(error == nil && snapshot != nil){
                            for document in snapshot!.documents{
                                let documentData = document.data()
                                
                                let tempLoan = Loan(loanId: documentData["loanId"] as! String as Any as! String, bookId: documentData["bookId"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookReturnedOn: documentData["bookReturnedOn"] as! String as Any as! String, loanStatus: documentData["loanStatus"] as! String as Any as! String, loanReminderStatus: documentData["loanReminderStatus"] as! String as Any as! String, fineCalculatedDays: documentData["fineCalculatedDays"] as! Int as Any as! Int, loanFine: documentData["loanFine"] as! Int as Any as! Int, createdOn: documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, timeStamp: documentData["timeStamp"] as! Int as Any as! Int)
                                
                                let date = dateFormatter.date(from:String(tempLoan.bookExpectedReturnOn.split(separator: ",")[0]))!
                                
                                var currentFine = tempLoan.loanFine
                                var currentDays = tempLoan.fineCalculatedDays
                                if(date < Date.now){
                                    
                                    let diffs = Calendar.current.dateComponents([.day], from: date, to: Date.now)
                                    if(currentDays < diffs.day! && diffs.day! > 0){
                                        for i in 0..<newConfig.fineDetails.count{
                                            if(currentDays < newConfig.fineDetails[i].period){
                                                currentFine += newConfig.fineDetails[i].fine
                                                currentDays += 1
                                                break
                                            }
                                            else{
                                                if( i == newConfig.fineDetails.count-1 && currentDays > newConfig.fineDetails[i].period){
                                                    currentFine += newConfig.fineDetails[i].fine
                                                    currentDays += 1
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                                self.dbInstance.collection("Loans").document(tempLoan.loanId).updateData(["loanFine":currentFine,"fineCalculatedDays":currentDays]){ error in
                                    if let error = error{
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.responseStatus = 400
                    self.responseMessage = "Something went wrong, Unable to get book. Check console for error"
                    print("Unable to get updated document. May be this could be the error: Book does not exist or db returned nil.")
                }
            } else {
                self.responseStatus = 400
                self.responseMessage = "Something went wrong, Unable to book. Check console for error"
                print("Unable to get book. Error: \(String(describing: error)).")
            }
            
        }
    }
    
    func fetchUserData(userID: String) {
        self.dbInstance.collection("users").document(userID).getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("User document not found")
                return
            }
            
            // Extract user data from the document
            let userData = document.data()
            var tempMember = UserSchema(userID: userData?["userId"] as? String ?? "", name: userData?["name"] as? String ?? "", email: userData?["email"] as? String ?? "", mobile: userData?["mobile"] as? String ?? "", profileImage: userData?["profileImage"] as? String ?? "", role: userData?["role"] as? String ?? "", activeFine: userData?["activeFine"] as? Int ?? 0, totalFined: userData?["totalFined"] as? Int ?? 0, penaltiesCount: userData?["penaltiesCount"] as? Int ?? 0, createdOn: Date.now, updateOn: Date.now, status: userData?["status"] as? String ?? "")
            
            self?.currentMember.append(tempMember)
        }
    }
    
    
    func fetchStaffData(staffID: String) {
        self.dbInstance.collection("users").document(staffID).getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("User document not found")
                return
            }
            
            let staffData = document.data()
            var tempMember = Staff(userID: staffData?["userID"] as? String ?? "", name: staffData?["name"] as? String ?? "", email: staffData?["email"] as? String ?? "", mobile: staffData?["mobile"] as? String ?? "", profileImageURL: staffData?["profileImage"] as? String ?? "", aadhar: staffData?["aadhar"] as? String ?? "", role: staffData?["role"] as? String ?? "", password: staffData?["password"] as? String ?? "", createdOn: Date.now, updatedOn: Date.now)
            
            self?.currentStaff.append(tempMember)
        }
    }
    
    
    
    func rateReview(bookId: String, rating: Int, review: String, loanId: String){
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
                    
                    
                    var tempCurrentBook = [ Book(id: document!["id"] as! String, bookISBN: document!["bookISBN"] as! String, bookImageURL: document!["bookImageURL"] as! String, bookName: document!["bookName"] as! String, bookAuthor: document!["bookAuthor"] as! String, bookDescription: document!["bookDescription"] as! String, bookCategory: document!["bookCategory"] as! String, bookSubCategories: document!["bookSubCategories"] as! [String], bookPublishingDate: document!["bookPublishingDate"] as! String, bookStatus: document!["bookStatus"] as! String, bookCount: document!["bookCount"] as! Int, bookAvailableCount:  document!["bookAvailableCount"] as! Int, bookPreBookedCount:  document!["bookPreBookedCount"] as! Int, bookTakenCount:  document!["bookTakenCount"] as! Int, bookIssuedTo: document!["bookIssuedTo"] as! [String], bookIssuedToName: document!["bookIssuedToName"] as! [String] as Any as! [String], bookIssuedOn: document!["bookIssuedOn"] as! [String], bookExpectedReturnOn: document!["bookExpectedReturnOn"] as! [String], bookRating: document!["bookRating"] as! Float, bookReviews: document!["bookReviews"] as! [String], bookHistory: bookHistoryArray, createdOn: document!["createdOn"] as! String, updayedOn: document!["updatedOn"] as! String) ]
                    
                    let newRating = Float((Float(tempCurrentBook[0].bookRating)+Float(rating))/2)
                    var newReviews: [String] = tempCurrentBook[0].bookReviews
                    newReviews.append(review)
                    
                    self.dbInstance.collection("Books").document(bookId).updateData(["bookRating":newRating, "bookReviews": newReviews, "updatedOn": Date.now.formatted()]){ error in
                        if let error = error{
                            print(error)
                        }
                        else{
                            self.dbInstance.collection("Loans").document(loanId).updateData(["loanStatus":"Completed"])
                        }
                    }
                }
                else{
                    self.responseStatus = 400
                    self.responseMessage = "Something went wrong, Unable to get book. Chek console for error"
                    print("Unable to get updated document. May be this could be the error: Book does not exist or db returned nil.")
                }
            }
            else{
                self.responseStatus = 400
                self.responseMessage = "Something went wrong, Unable to book. Chek console for error"
                print("Unable to get book. Error: \(String(describing: error)).")
            }
        }
    }
    
    func fetchConfig(){
        dbInstance.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").getDocument { document, error in
            if error == nil {
                if document != nil && document!.exists {
                    
                    guard let fineDetailsDictArray = document!["fineDetails"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }

                    var fineDetailsArray: [fineDetails] = []
                    for fineDetailDict in fineDetailsDictArray {
                        guard let fine = fineDetailDict["fine"] as? Int,
                              let period = fineDetailDict["period"] as? Int else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let fineDetail = fineDetails(fine: fine, period: period)
                        fineDetailsArray.append(fineDetail)
                        
                    }
                    
                    guard let monthlyMembersCountDictArray = document!["monthlyMembersCount"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                        return
                    }

                    var monthlyMembersCountArray: [membersCount] = []
                    for memberCountDict in monthlyMembersCountDictArray {
                        guard let month = memberCountDict["month"] as? String,
                              let count = memberCountDict["count"] as? Int else {
                            print("Error: Unable to parse memberCount from dictionary")
                            continue
                        }
                        
                        let memberCount = membersCount(month: month, count: count)
                        monthlyMembersCountArray.append(memberCount)
                    }
                    
                    guard let monthlyIncomeDictArray = document!["monthlyIncome"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                        return
                    }
                    
                    var monthlyIncomeArray: [monthlyIncome] = []
                    for memberIncomeDict in monthlyIncomeDictArray {
                        guard let month = memberIncomeDict["month"] as? String,
                              let count = memberIncomeDict["income"] as? Int else {
                            print("Error: Unable to parse memberCount from dictionary")
                            continue
                        }
                        
                        let monthlyIncome = monthlyIncome(month: month, income: count)
                        monthlyIncomeArray.append(monthlyIncome)
                    }
                  
                    var newConfig = Config(
                        configID: document!["configID"] as! String,
                        adminID: document!["adminID"] as! String,
                        logo: document!["logo"] as! String,
                        accentColor: document!["accentColor"] as! String,
                        loanPeriod: document!["loanPeriod"] as! Int,
                        fineDetails: fineDetailsArray,
                        maxFine: document!["maxFine"] as! Double,
                        maxPenalties: document!["maxPenalties"] as! Int,
                        categories: document!["categories"] as! [String],
                        monthlyMembersCount: monthlyMembersCountArray, monthlyIncome: monthlyIncomeArray)
                    print(newConfig)
                    self.currentConfig.append(newConfig)
                    self.responseStatus = 200
                    self.responseMessage = "Book fetched successfully"
                } else {
                    self.responseStatus = 200
                    self.responseMessage = "Something went wrong, Unable to get book. Check console for error"
                    print("Unable to get updated document. May be this could be the error: Book does not exist or db returned nil.")
                }
            } else {
                self.responseStatus = 200
                self.responseMessage = "Something went wrong, Unable to book. Check console for error"
                print("Unable to get book. Error: \(String(describing: error)).")
            }
        }
    }
    
    func getCategoryStat() async{
        
        fetchConfig()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        var tempCategoryStat: [categoryStats] = []
        
        for i in currentConfig[0].categories{
            tempCategoryStat.append(categoryStats(category: i, count: 0))
        }
        
        self.getBooks()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        for i in allBooks{
            for j in 0..<tempCategoryStat.count{
                if(i.bookCategory == tempCategoryStat[j].category){
                    tempCategoryStat[j].count += 1
                }
            }
        }
        
        tempCategoryStat.sort { $0.count > $1.count }
        
        var total: Int = 0
        
        for i in 3..<tempCategoryStat.count{
            total += tempCategoryStat[i].count
        }
        
        self.categoryStat = [categoryStats(category: tempCategoryStat[0].category, count: tempCategoryStat[0].count),categoryStats(category: tempCategoryStat[1].category, count: tempCategoryStat[1].count),categoryStats(category: tempCategoryStat[2].category, count: tempCategoryStat[2].count),
        categoryStats(category: "Others", count: total)]
        
    }
    
}
