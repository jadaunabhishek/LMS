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
    @Published var staff: [Staff] = []
    @Published var allStaffs: [Staff] = []
    @Published var currentAdmin: [Admin] = []
    
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
        let imageData = profilePhoto.jpegData(compressionQuality: 0.1)!
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
                    if let userId = authResult?.user.uid{
                        let addNewStaff = self.dbInstance.collection("users").document(userId)
                        let newStaff = Staff(
                            userID: addNewStaff.documentID ,
                            name: name,
                            email: email,
                            mobile: mobile,
                            profileImageURL: imageURL,
                            aadhar: aadhar,
                            role: role,
                            password: password,
                            createdOn: Date(),
                            updatedOn: Date()
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
    }
    
    func getAllStaff() {
            self.dbInstance.collection("users").whereField("role", isEqualTo: "librarian").getDocuments { querySnapshot, error in
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
                        updatedOn: (data["updatedOn"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }
            }
        }
    
    func getStaff() {
        self.dbInstance.collection("users").whereField("role", isEqualTo: "librarian").getDocuments { querySnapshot, error in
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
                    updatedOn: (data["updatedOn"] as? Timestamp)?.dateValue() ?? Date()
                )
                librarians.append(librarian)
            }
            self.currentStaff = librarians
        }
    }
    
    func updateStaff(
        staffID: String,
        name: String,
        email: String,
        mobile: String,
        aadhar: String,
        profilePhoto: UIImage,
        isImageUpdated: Bool,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        self.responseStatus = 0
        self.responseMessage = ""
        
        if isImageUpdated {
            let storageRef = Storage.storage().reference()
            let imageData = profilePhoto.jpegData(compressionQuality: 0.1)!
            let fileRef = storageRef.child("staffProfileImages/\(staffID).jpeg")
            
            fileRef.putData(imageData, metadata: nil) { metadata, error in
                guard error == nil, metadata != nil else {
                    completion(false, error)
                    return
                }
                
                fileRef.downloadURL { url, error in
                    guard let imageURL = url?.absoluteString, error == nil else {
                        completion(false, error)
                        return
                    }
                    
                    self.dbInstance.collection("users").document(staffID).updateData([
                        "name": name,
                        "email": email,
                        "mobile": mobile,
                        "aadhar": aadhar,
                        "profileImageURL": imageURL
                    ]) { [self] error in
                        if let error = error {
                            completion(false, error)
                            self.responseStatus = 400
                            self.responseMessage = "Something went wrong, Unable to update staff member. Check console for error."
                            print("Unable to update staff member. Error: \(error)")
                        } else {
                            completion(true, nil)
                            self.getStaff()
                            self.responseStatus = 200
                            self.responseMessage = "Staff member updated successfully."
                        }
                    }
                }
            }
        } else {
            self.dbInstance.collection("users").document(staffID).updateData([
                "name": name,
                "email": email,
                "mobile": mobile,
                "aadhar": aadhar,
            ]) { error in
                if let error = error {
                    completion(false, error)
                    self.responseStatus = 400
                    self.responseMessage = "Something went wrong, Unable to update staff member. Check console for error."
                    print("Unable to update staff member. Error: \(error)")
                } else {
                    completion(true, nil)
                    self.getStaff()
                    self.responseStatus = 200
                    self.responseMessage = "Staff member updated successfully."
                }
            }
        }
    }
    
    func deleteStaff(staffID: String) {
        self.responseStatus = 0
        self.responseMessage = ""
        
        self.dbInstance.collection("users").document(staffID).delete { error in
            if let error = error {
                self.responseStatus = 400
                self.responseMessage = "Something went wrong, Unable to delete staff member. Check console for errors."
                print("Unable to delete staff member. Error: \(error)")
            } else {
                self.responseStatus = 200
                self.responseMessage = "Deleted staff member successfully."
            }
        }
    }
    
    func fetchStaffData(staffID: String) {
        self.dbInstance.collection("users").document(staffID).getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("User document not found")
                return
            }
            
            let userData = document.data()
            var tempMember = Staff(userID: userData?["userId"] as? String ?? "", name: userData?["name"] as? String ?? "", email: userData?["email"] as? String ?? "", mobile: userData?["mobile"] as? String ?? "", profileImageURL: userData?["profileImageURL"] as? String ?? "", aadhar: userData?["aadhar"] as? String ?? "", role: userData?["role"] as? String ?? "", password: "", createdOn: (userData?["createdOn"] as? Timestamp)?.dateValue() ?? Date(), updatedOn: (userData?["updatedOn"] as? Timestamp)?.dateValue() ?? Date())
            
            self?.staff.append(tempMember)
        }
    }
    
    func fetchAdminData() {
        self.dbInstance.collection("users").document("cYlLVOR8LnO9AEpBxEpb").getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("User document not found")
                return
            }
            
            let userData = document.data()
            var tempMember = Admin(name: userData?["name"] as? String ?? "", email: userData?["email"] as? String ?? "", mobile: userData?["mobile"] as? String ?? "", profileImageURL: userData?["profileImageURL"] as? String ?? "")
            
            self?.currentAdmin.append(tempMember)
        }
    }
}
