//
//  StaffSchema.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import Foundation

struct Staff {
    var staffID: String
    var staffName: String
    var staffEmail: String
    var staffMobile: String
    var staffImageURL: String
    var staffAadhar: String
    var staffRole: StaffRole
    var staffPassword: String
    var createdOn: Date
    var updatedOn: Date
    var status: Status
    
    enum StaffRole: String {
        case librarian = "Librarian"
        case staff = "Staff"
    }
    
    enum Status: String {
        case active = "Active"
        case revoked = "Revoked"
    }
    
    func getDictionaryOfStruct() -> [String: Any] {
        return [
            "staffID": staffID,
            "staffName": staffName,
            "staffEmail": staffEmail,
            "staffMobile": staffMobile,
            "staffImageURL": staffImageURL,
            "staffAadhar": staffAadhar,
            "staffRole": staffRole.rawValue,
            "staffPassword": staffPassword,
            "createdOn": createdOn,
            "updatedOn": updatedOn,
            "status": status.rawValue
        ]
    }
}
