//
//  StaffSchema.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import Foundation

struct Staff: Identifiable {
    var id: String
    var userID: String
    var name: String
    var email: String
    var mobile: String
    var profileImageURL: String
    var aadhar: String
    var role: String
    var password: String
    var createdOn: Date
    var updatedOn: Date
    
    init(userID: String, name: String, email: String, mobile: String, profileImageURL: String, aadhar: String, role: String, password: String, createdOn: Date, updatedOn: Date) {
        self.id = userID
        self.userID = userID
        self.name = name
        self.email = email
        self.mobile = mobile
        self.profileImageURL = profileImageURL
        self.aadhar = aadhar
        self.role = role
        self.password = password
        self.createdOn = createdOn
        self.updatedOn = updatedOn
    }
    
    func getDictionaryOfStruct() -> [String: Any] {
        return [
            "userID": userID,
            "name": name,
            "email": email,
            "mobile": mobile,
            "profileImageURL": profileImageURL,
            "aadhar": aadhar,
            "role": role,
            "password": password,
            "createdOn": createdOn,
            "updatedOn": updatedOn,
        ]
    }
}
