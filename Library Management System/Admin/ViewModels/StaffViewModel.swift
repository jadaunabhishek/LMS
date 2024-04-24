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
        name: String,
        email: String,
        mobile: String,
        aadhar: String,
        role: Staff.Role,
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
                
                let password = "\(name.prefix(4))123$"
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, authError in
                    guard authError == nil, let _ = authResult else {
                        completion(false, authError)
                        return
                    }
                    
                    let newStaff = Staff(
                        userID: authResult!.user.uid,
                        name: name,
                        email: email,
                        mobile: mobile,
                        profileImageURL: imageURL,
                        aadhar: aadhar,
                        role: .librarian,
                        password: password,
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
}
