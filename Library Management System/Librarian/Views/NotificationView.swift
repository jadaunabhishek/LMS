import SwiftUI

enum NotificationType {
    case membershipRequest, grievance
}

struct NotificationItem: Identifiable {
    var id = UUID()
    var name: String
    var message: String
    var type: NotificationType
    var date: String
    var detail: String? // Only for grievances
}

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = [
        // Populate with initial data
        NotificationItem(name: "John Doe", message: "Membership Request", type: .membershipRequest, date: "23:35"),
        NotificationItem(name: "John Doe", message: "GRIEVANCE", type: .grievance, date: "23:35", detail: "Detailed grievance text here"),
        // More notifications...
    ]
    
    func approve(notification: NotificationItem) {
        // Handle approval
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].message = "Approved" // Update the UI
        }
    }
    
    func reject(notification: NotificationItem) {
        // Handle rejection
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].message = "Rejected" // Update the UI
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
                    Text(notification.date).font(.footnote).foregroundColor(.gray)
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
            NotificationItem(name: "John Doe", message: "Membership Request", type: .membershipRequest, date: "23:35"),
            NotificationItem(name: "Jane Smith", message: "GRIEVANCE", type: .grievance, date: "23:40", detail: "Lorem ipsum dolor sit amet...")
        ]

        return NotificationsView(viewModel: viewModel)
    }
}


struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        // Create a preview instance of your NotificationsViewModel
        let viewModel = NotificationsViewModel()

        // Add preview data for a single notification
        let membershipRequest = NotificationItem(name: "John Doe", message: "Membership Request", type: .membershipRequest, date: "23:35")
        let grievance = NotificationItem(name: "Jane Smith", message: "GRIEVANCE", type: .grievance, date: "23:40", detail: "Lorem ipsum dolor sit amet...")

        Group {
            NotificationRow(viewModel: viewModel, notification: membershipRequest)
            NotificationRow(viewModel: viewModel, notification: grievance)
        }
        .previewLayout(.sizeThatFits)
    }
}
