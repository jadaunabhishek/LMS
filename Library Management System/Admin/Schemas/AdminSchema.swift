//
//  AdminSchema.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 10/05/24.
//

import Foundation

struct Admin {
    var name: String
    var email: String
    var mobile: String
    var profileImageURL: String
    
    func getDictionaryOfStruct() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "mobile": mobile,
            "profileImageURL": profileImageURL
        ]
    }
}
