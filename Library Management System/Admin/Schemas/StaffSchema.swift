//
//  StaffSchema.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import Foundation

struct Staff {
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
