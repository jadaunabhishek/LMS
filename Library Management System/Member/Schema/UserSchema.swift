//
//  UserSchema.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 02/05/24.
//

import SwiftUI

struct UserSchema{

    var userID: String
    var name: String
    var email: String
    var mobile: String
    var profileImage: String
    var role: String
    var activeFine: Int
    var totalFined: Int
    var penaltiesCount: Int
    var createdOn: Date
    var updateOn: Date
    var status: String
    
    func getDictionaryOfUserSchema() -> [String:Any]{
        
        return [
        
            "userID": userID,
            "name": name,
            "email": email,
            "mobile": mobile,
            "profileImage": profileImage,
            "role": role,
            "activeFine": activeFine,
            "totalFined": totalFined,
            "penaltiesCount": penaltiesCount,
            "createdOn": createdOn,
            "updateOn": updateOn,
            "status": status
        
        ]
        
    }
    
}
