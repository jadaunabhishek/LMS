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
        db.collection("users").order(by: "createdOn", descending: false).whereField("role", isEqualTo: "user").whereField("status", isEqualTo: "applied")
          .addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var newNotifications = [NotificationItem]()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"

            for document in documents {
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

            self!.notifications = newNotifications
            self?.updateFilteredNotifications()
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
        ]) { error in
            if let error = error {
                print("Error updating user role: \(error.localizedDescription)")
            } else {
                print("User role successfully updated to 'member'")
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].message = "Approved"
                    self.updateFilteredNotifications()
                }
            }
        }
    }

    func reject(notification: NotificationItem) {
        let userDocRef = db.collection("users").document(notification.id)
        userDocRef.updateData([
            "status": "rejected"
        ]) { error in
            if let error = error {
                print("Error updating user status: \(error.localizedDescription)")
            } else {
                print("User status successfully updated to 'rejected'")
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].message = "Rejected"
                    self.updateFilteredNotifications()
                }
            }
        }
    }
}
