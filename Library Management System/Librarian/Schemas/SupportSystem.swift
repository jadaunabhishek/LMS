import Foundation

struct SupportTicket: Identifiable {
    var id: String
    var senderID: String
    var name: String
    var email: String
    var phoneNumber: String
    var description: String
    var status: String
    var handledBy: String
    var createdOn: String
    var updatedOn: String
    var reply: String
    var LibName: String
    var Subject: String
    
    func getDeict() -> [String:Any]{
        return [
            "id":id,
            "senderID":senderID,
            "name":name,
            "email":email,
            "phoneNumber":phoneNumber,
            "description":description,
            "status":status,
            "handledBy":handledBy,
            "createdOn":createdOn,
            "updatedOn":updatedOn,
            "reply":reply,
            "LibName":LibName,
            "Subject":Subject
        ]
    }
}
