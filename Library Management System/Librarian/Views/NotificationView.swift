import SwiftUI
import FirebaseFirestore


struct User: Identifiable {
    var id: String
    var email: String
    var role: String
    var name: String
}


enum NotificationType {
    case membershipRequest, grievance
}

struct NotificationItem: Identifiable {
    var id : String
    var name: String
    var message: String
    var type: NotificationType
    var email: String
    var detail: String? // Only for grievances
}

class NotificationsViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var notifications = [NotificationItem]()

    private var db = Firestore.firestore()

    init() {
        fetchData()
    }

    func fetchData() {
        db.collection("users").whereField("role", isEqualTo: "user").whereField("status", isEqualTo: "applied")
          .addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self?.users = documents.map { doc -> User in
                let data = doc.data()
                let email = data["email"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                return User(id: doc.documentID, email: email, role: "user", name: name)
            }

            self?.createNotifications()
        }

    }

    private func createNotifications() {
        notifications = users.map { user in
            NotificationItem(
                id: user.id,
                name: user.name,
                message: "Role: \(user.role)",
                type: user.role == "grievance" ? .grievance : .membershipRequest,
                email:user.email,
                detail: user.role == "grievance" ? "Needs immediate attention" : nil
            )
        }
    }


    func approve(notification: NotificationItem) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(notification.id)
        // Update logic if needed in Firestore or locally
        userDocRef.updateData([
                "role": "member",
                "status" : "approved"
            ]) { error in
                if let error = error {
                    print("Error updating user role: \(error.localizedDescription)")
                } else {
                    print("User role successfully updated to 'member'")
                    // Optionally update local notifications array if needed
                    if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                        self.notifications[index].message = "Approved"
                    }
                }
            }
    }

    func reject(notification: NotificationItem) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(notification.id)
        // Update logic if needed in Firestore or locally
        userDocRef.updateData([
            "status" : "rejected"
            ]) { error in
                if let error = error {
                    print("Error updating user role: \(error.localizedDescription)")
                } else {
                    print("User role successfully updated to 'member'")
                    // Optionally update local notifications array if needed
                    if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                        self.notifications[index].message = "Approved"
                    }
                }
            }
    }
}

struct NotificationRow: View {
    @ObservedObject var viewModel: NotificationsViewModel
    var notification: NotificationItem
    @State private var isShowingGrievanceDetail = false // Here is the correct state variable declaration

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: notification.type == .membershipRequest ? "person.fill" : "message.fill")
                    .foregroundColor(.orange)
                    .frame(width: 32, height: 32)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))

                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.name).font(.headline)
                    Text(notification.message).font(.subheadline)
                    Text(notification.email).font(.footnote).foregroundColor(.gray)
                }
                
                Spacer()
                
                if notification.type == .membershipRequest {
                    Button(action: {
                        viewModel.approve(notification: notification)
                    }) {
                        Label("Approve", systemImage: "checkmark")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(.green)
                    
                    Button(action: {
                        viewModel.reject(notification: notification)
                    }) {
                        Label("Reject", systemImage: "xmark")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(.red)
                } else {
                    Text(">")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if notification.type == .grievance, isShowingGrievanceDetail { // Use the corrected state variable name
                Text(notification.detail ?? "")
                    .padding([.horizontal, .bottom])
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .onTapGesture {
            if notification.type == .grievance {
                self.isShowingGrievanceDetail = true // Use the corrected state variable name
            }
        }
        .sheet(isPresented: $isShowingGrievanceDetail) { // Use the corrected state variable name
            GrievanceDetailView(grievance: notification.detail ?? "No details provided", viewModel: viewModel, notification: notification)
        }
        .onAppear {
            self.viewModel.fetchData()
        }
    }
}




struct GrievanceDetailView: View {
    let grievance: String
    @ObservedObject var viewModel: NotificationsViewModel
    var notification: NotificationItem
    @State private var replyText: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ScrollView {
                Text(grievance)
                    .padding()
            }
            
            HStack {
                TextField("Reply...", text: $replyText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Send") {
                    // Handle sending the reply here.
                    // You might want to add the reply to the 'notification' or inform the viewModel.
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .disabled(replyText.isEmpty)
            }
        }
        .navigationBarTitle("Grievance Detail", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}



struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationRow(viewModel: viewModel, notification: notification)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemGroupedBackground)) // Matches iOS group background
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "bell.fill").foregroundColor(.orange)
                        Text("Notifications").font(.headline)
                    }
                }
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        // You can create a mock NotificationsViewModel with sample data for the preview
        let viewModel = NotificationsViewModel()
        viewModel.notifications = [
            NotificationItem(id: "1" ,name: "John Doe", message: "Membership Request", type: .membershipRequest, email:"john@gmail.com")
        ]

        return NotificationsView(viewModel: viewModel)
    }
}
