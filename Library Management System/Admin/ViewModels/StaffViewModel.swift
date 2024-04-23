//
//  StaffViewModel.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class StaffViewModel: ObservableObject {
    private let dbInstance = Firestore.firestore()
    
    func addStaff(
        staffName: String,
        staffEmail: String,
        staffMobile: String,
        staffAadhar: String,
        staffRole: Staff.StaffRole,
        profilePhoto: UIImage,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let addNewStaff = dbInstance.collection("users").document()
        let storageRef = Storage.storage().reference()
        let imageData = profilePhoto.jpegData(compressionQuality: 0.9)!
        let fileRef = storageRef.child("staffProfileImages/\(addNewStaff.documentID).jpeg")
        
        fileRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(false, error)
                return
            }
            
            fileRef.downloadURL { url, error in
                guard let imageURL = url?.absoluteString, error == nil else {
                    completion(false, error)
                    return
                }
                
                let password = "\(staffName.prefix(4))123$"
                
                let newStaff = Staff(
                    staffID: addNewStaff.documentID,
                    staffName: staffName,
                    staffEmail: staffEmail,
                    staffMobile: staffMobile,
                    staffImageURL: imageURL,
                    staffAadhar: staffAadhar,
                    staffRole: staffRole,
                    staffPassword: password,
                    createdOn: Date(),
                    updatedOn: Date(),
                    status: .active
                )
                
                addNewStaff.setData(newStaff.getDictionaryOfStruct()) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
