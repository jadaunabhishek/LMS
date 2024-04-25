import Foundation

struct History{
    
    var userId: String
    var issuedOn: String
    var returnedOn: String
    
}

struct Book{
    
    var id: String
    var bookISBN: String
    var bookImageURL: String
    var bookName: String
    var bookAuthor: String
    var bookDescription: String
    var bookCategory: String
    var bookSubCategory: [String]
    var bookPublishingDate: String
    var bookStatus: String
    var bookIssuedTo: String
    var bookIssuedOn: String
    var bookExpectedReturnOn: String
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
            "bookPublishingDate": bookPublishingDate,
            "bookStatus": bookStatus,
            "bookIssuedTo": bookIssuedTo,
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
