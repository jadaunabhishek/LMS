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
import FirebaseAuth

class StaffViewModel: ObservableObject {
    
    private let dbInstance = Firestore.firestore()
    
    @Published var responseStatus = 0
    @Published var responseMessage = ""
    
    @Published var currentStaff: [Staff] = []
    
    func addStaff(
        name: String,
        email: String,
        mobile: String,
        aadhar: String,
        role: String,
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
                        role: role,
                        password: password,
                        createdOn: Date(),
                        updatedOn: Date(),
                        status: .active
                    )
                    
                    addNewStaff.setData(newStaff.getDictionaryOfStruct()) { error in
                        if let error = error {
                            completion(false, error)
                            self.responseStatus = 400
                            self.responseMessage = "Something went wrong, Unable to add staff member. Check console for error."
                            print("Unable to add staff member. Error: \(error)")
                        } else {
                            completion(true, nil)
                            self.responseStatus = 200
                            self.responseMessage = "Staff member added successfully."
                        }
                    }
                }
            }
        }
    }

    func getStaff() {
        self.dbInstance.collection("users").whereField("role", isEqualTo: "Librarian").getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching librarians: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var librarians = [Staff]()
            for document in querySnapshot.documents {
                let data = document.data()
                let librarian = Staff(
                    userID: document.documentID,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    mobile: data["mobile"] as? String ?? "",
                    profileImageURL: data["profileImageURL"] as? String ?? "",
                    aadhar: data["aadhar"] as? String ?? "",
                    role: data["role"] as? String ?? "",
                    password: data["password"] as? String ?? "",
                    createdOn: (data["createdOn"] as? Timestamp)?.dateValue() ?? Date(),
                    updatedOn: (data["updatedOn"] as? Timestamp)?.dateValue() ?? Date(),
                    status: Staff.Status(rawValue: data["status"] as? String ?? "") ?? .active
                )
                librarians.append(librarian)
            }

            self.currentStaff = librarians
        }
    }

}
