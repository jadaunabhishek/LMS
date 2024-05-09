//
//  ConfigVIewModel.swift
//  Library Management System
//
//  Created by user2 on 24/04/24.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ConfigViewModel: ObservableObject {
    
    private let dbInstance = Firestore.firestore()
    @Published var responseStatus = 0
    @Published var responseMessage = ""
    @Published var currentConfig: [Config] = []

    init(){
        fetchConfig()
    }
    
    func fetchConfig(){
        dbInstance.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").getDocument { document, error in
            if error == nil {
                if document != nil && document!.exists {
                    
                    guard let fineDetailsDictArray = document!["fineDetails"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }

                    var fineDetailsArray: [fineDetails] = []
                    for fineDetailDict in fineDetailsDictArray {
                        guard let fine = fineDetailDict["fine"] as? Int,
                              let period = fineDetailDict["period"] as? Int else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let fineDetail = fineDetails(fine: fine, period: period)
                        fineDetailsArray.append(fineDetail)
                        
                    }
                    
                    guard let monthlyMembersCountDictArray = document!["monthlyMembersCount"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                        return
                    }

                    var monthlyMembersCountArray: [membersCount] = []
                    for memberCountDict in monthlyMembersCountDictArray {
                        guard let month = memberCountDict["month"] as? String,
                              let count = memberCountDict["count"] as? Int else {
                            print("Error: Unable to parse memberCount from dictionary")
                            continue
                        }
                        
                        let memberCount = membersCount(month: month, count: count)
                        monthlyMembersCountArray.append(memberCount)
                    }

                    
                    guard let monthlyIncomeDictArray = document!["monthlyIncome"] as? [[String: Any]] else {
                        print("Error: Unable to parse monthlyMembersCount array from Firestore document")
                        return
                    }
                    
                    var monthlyIncomeArray: [monthlyIncome] = []
                    for memberIncomeDict in monthlyIncomeDictArray {
                        guard let month = memberIncomeDict["month"] as? String,
                              let count = memberIncomeDict["income"] as? Int else {
                            print("Error: Unable to parse memberCount from dictionary")
                            continue
                        }
                        
                        let monthlyIncome = monthlyIncome(month: month, income: count)
                        monthlyIncomeArray.append(monthlyIncome)
                    }

                    
                    var newConfig = Config(
                        configID: document!["configID"] as! String,
                        adminID: document!["adminID"] as! String,
                        logo: document!["logo"] as! String,
                        accentColor: document!["accentColor"] as! String,
                        loanPeriod: document!["loanPeriod"] as! Int,
                        fineDetails: fineDetailsArray,
                        maxFine: document!["maxFine"] as! Double,
                        maxPenalties: document!["maxPenalties"] as! Int,
                        categories: document!["categories"] as! [String],
                        monthlyMembersCount: monthlyMembersCountArray, monthlyIncome: monthlyIncomeArray)
                    print(newConfig)
                    self.currentConfig.append(newConfig)
                    self.responseStatus = 200
                    self.responseMessage = "Book fetched successfully"
                } else {
                    self.responseStatus = 200
                    self.responseMessage = "Something went wrong, Unable to get book. Check console for error"
                    print("Unable to get updated document. May be this could be the error: Book does not exist or db returned nil.")
                }
            } else {
                self.responseStatus = 200
                self.responseMessage = "Something went wrong, Unable to book. Check console for error"
                print("Unable to get book. Error: \(String(describing: error)).")
            }
        }
    }


    func addCategory( configId: String, categories: [String] ){
        
        dbInstance.collection("configuration").document(configId).updateData(["categories":categories]){ (error) in
            
            if let error = error{
                print("\(error)")
            }
            else{
                self.fetchConfig()
                print("Done")
            }
        }
        
    }
    
    
    func updateCategory(configId:String, categories:[String]){
        dbInstance.collection("configuration").document(configId).updateData(["categories":categories]){ (error) in
            
            if let error = error{
                print("\(error)")
            }
            else{
                self.fetchConfig()
            }
        }
    }
    
    func updateLibraryLogo(libraryLogo: UIImage, configId: String){
        
        let storageRef = Storage.storage().reference()
        let imageData  = libraryLogo.pngData()!
        let fileRef = storageRef.child("libraryLogos/\(configId).jpeg")
        
        //var uploadDone  = false
        fileRef.putData(imageData, metadata: nil){
            metadata,error in
            
            if(error == nil && metadata != nil){
                fileRef.downloadURL{ url,error1 in
                    if(error1 == nil && url != nil){
                        let imageURL = url?.absoluteString
                        self.dbInstance.collection("configuration").document(configId).updateData(["logo":imageURL as Any]){ error in
                            if let error = error{
                                print("Unable to update Logo")
                            }
                            else{
                                print("Logo updated")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateLibraryTheme(configId: String, acentColor: String){
        self.dbInstance.collection("configuration").document(configId).updateData(["accentColor": acentColor]){ error in
            if let error = error{
                print("Unable to update theme")
            }
            else{
                print("Logo updated")
            }
        }
    }
    
    func updateLibraryFineDetails(configId: String, loanPeriod: Int, maxFine: Int, maxPenalties: Int, fineDetails: [[String: Any]]){
        self.dbInstance.collection("configuration").document(configId).updateData(["loanPeriod": loanPeriod, "maxFine": maxFine, "maxPenalties": maxPenalties, "fineDetails": fineDetails]){ error in
            if let error = error{
                print("Unable to update fine Details")
            }
            else{
                print("Logo updated")
            }
        }
    }
    
    func updateFineAndLoan(configId: String, fineDetails: [fineDetails], loanPeriod: Int, maxFine: Double, maxPenalty: Int) {
        let fineDetailsArray = fineDetails.map { $0.getDictionary() }
        dbInstance.collection("configuration").document(configId).updateData([
            "fineDetails": fineDetailsArray,
            "loanPeriod": loanPeriod,
            "maxFine": maxFine,
            "maxPenalties": maxPenalty
        ]) { error in
            if let error = error {
                print("Error updating configuration: \(error)")
            } else {
                self.fetchConfig()
                print("Configuration updated successfully")
            }
        }
    }
}
