import Foundation

struct History{
    
    var userId: String
    var userName: String
    var issuedOn: String
    var returnedOn: String
    
    func getDictionaryOfStruct() -> [String:Any]{
        
        return [
            
            "userId": userId,
            "userName": userName,
            "issuedOn": issuedOn,
            "returnedOn": returnedOn
            
        ]
        
    }
    
}

struct Book{
    
    var id: String
    var bookISBN: String
    var bookImageURL: String
    var bookName: String
    var bookAuthor: String
    var bookDescription: String
    var bookCategory: String
    var bookSubCategories: [String]
    var bookPublishingDate: String
    var bookStatus: String
    var bookCount: Int
    var bookAvailableCount: Int
    var bookPreBookedCount: Int
    var bookTakenCount: Int
    var bookIssuedTo: [String]
    var bookIssuedToName: [String]
    var bookIssuedOn: [String]
    var bookExpectedReturnOn: [String]
    var bookRating: Float
    var bookReviews: [String]
    var bookHistory: [History]
    var createdOn: String
    var updayedOn: String
    
    func getDictionaryOfStruct() -> [String:Any]{
        
        return [
        
            "id": id,
            "bookISBN": bookISBN,
            "bookImageURL": bookImageURL,
            "bookName": bookName,
            "bookAuthor": bookAuthor,
            "bookDescription": bookDescription,
            "bookCategory": bookCategory,
            "bookSubCategories": bookSubCategories,
            "bookPublishingDate": bookPublishingDate,
            "bookStatus": bookStatus,
            "bookCount": bookCount,
            "bookAvailableCount": bookAvailableCount,
            "bookPreBookedCount": bookPreBookedCount,
            "bookTakenCount": bookTakenCount,
            "bookIssuedTo": bookIssuedTo,
            "bookIssuedToName": bookIssuedToName,
            "bookIssuedOn": bookIssuedOn,
            "bookExpectedReturnOn": bookExpectedReturnOn,
            "bookRating": bookRating,
            "bookReviews": bookReviews,
            "bookHistory": bookHistory,
            "createdOn": createdOn,
            "updatedOn": updayedOn
        
        ]
        
    }
    
}
