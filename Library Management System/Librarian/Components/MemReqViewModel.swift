//
//  MemReqViewModel.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 03/05/24.
//

import Foundation
import Firebase
import FirebaseFirestore
// Enum to differentiate between types of notifications
enum NotificationType {
    case membershipApproval, bookBooking
}

struct User: Identifiable {
    var id: String
    var email: String
    var role: String
    var name: String
}

// Data model for notifications
struct NotificationItem: Identifiable {
    var id: String
    var name: String
    var message: String
    var type: NotificationType
    var detail: String
    var email: String
    var role: String
    var date: Date
}

// ViewModel to manage fetching and updating data
class NotificationsViewModel: ObservableObject {
    
    @Published var notifications: [NotificationItem] = []
    @Published var filteredNotifications = [String: [NotificationItem]]()
    @Published var segmentIndex = 0  // For segmented control

    private var db = Firestore.firestore()

    init() {
        fetchData()
    }

    func fetchData() {
        db.collection("users").order(by: "createdOn", descending: false).whereField("role", isEqualTo: "user").whereField("status", isEqualTo: "applied").getDocuments { (snapshot, error) in

            var newNotifications = [NotificationItem]()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"

              if(error == nil && snapshot != nil){
                  for document in snapshot!.documents {
                      let data = document.data()
                      let email = data["email"] as? String ?? ""
                      let name = data["name"] as? String ?? ""
                      let role = data["role"] as? String ?? "Unknown Role"
                      let id = document.documentID
                      let type: NotificationType = (role == "book") ? .bookBooking : .membershipApproval
                      let detail = (type == .bookBooking) ? "Book Request: \(name)" : "Membership Approval for \(name)"

                      let item = NotificationItem(id: id, name: name, message: "Notification for \(role)", type: type, detail: detail, email: email, role: role, date: Date())
                      newNotifications.append(item)
                  }
              }
            self.notifications = newNotifications
            self.updateFilteredNotifications()
        }
    }

    func updateFilteredNotifications() {
        let filtered = notifications.filter { item in
            (segmentIndex == 0 && item.type == .bookBooking) || (segmentIndex == 1 && item.type == .membershipApproval)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"

        let grouped = Dictionary(grouping: filtered) { (element) -> String in
            if Calendar.current.isDateInToday(element.date) {
                return "Today"
            } else if Calendar.current.isDateInYesterday(element.date) {
                return "Yesterday"
            } else {
                return dateFormatter.string(from: element.date)
            }
        }
        filteredNotifications = grouped
    }

    func approve(notification: NotificationItem) {
        let userDocRef = db.collection("users").document(notification.id)
        userDocRef.updateData([
            "role": "member",
            "status": "approved"
        ]) { [self] error in
            if let error = error {
                print("Error updating user role: \(error.localizedDescription)")
            } else {
                //self.fetchData()
                print("User role successfully updated to 'member'")
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].message = "Approved"
                    db.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").getDocument{ (document,error) in
                        if error == nil{
                            if (document != nil && document!.exists){
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
                                
                                if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
                                    let monthStr = Calendar.current.monthSymbols[monthInt-1]
                                    
                                    for i in 0..<newConfig.monthlyMembersCount.count{
                                        if(newConfig.monthlyMembersCount[i].month == monthStr){
                                            newConfig.monthlyMembersCount[i].count += 1
                                        }
                                    }
                                    self.db.collection("configuration").document("HJ9L6mDbi01TJvX3ja7Z").setData(newConfig.getDictionaryOfStruct()){ error in
                                        if let error = error{
                                            print(error)
                                        }
                                        else{
                                            print("Done")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.updateFilteredNotifications()
                }
            }
        }
    }

    func reject(notification: NotificationItem) {
        let userDocRef = db.collection("users").document(notification.id)
        userDocRef.updateData([
            "role":"user",
            "status": "rejected"
        ]) { error in
            if let error = error {
                print("Error updating user status: \(error.localizedDescription)")
            } else {
                //self.fetchData()
                print("User status successfully updated to 'rejected'")
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].message = "Rejected"
                    self.updateFilteredNotifications()
                }
            }
        }
    }
    
}
