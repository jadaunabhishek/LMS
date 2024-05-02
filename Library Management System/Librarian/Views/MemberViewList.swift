import SwiftUI
import FirebaseFirestore

// Define the Member struct to hold member information
struct Member {
    let id: String
    var name: String
    var email: String
    var status: String
    var isToggled: Bool
}

// View for displaying individual member cards
struct MemberCard: View {
    var db = Firestore.firestore()
    @Binding var member: Member

    // Update member status in Firestore
    func updateData(memberId: String, status: String) {
        db.collection("users").document(memberId).updateData(["status": status])
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.orange)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(member.name)
                        .font(.headline)
                    Text(member.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Status: \(member.status)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Toggle("", isOn: $member.isToggled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .onChange(of: member.isToggled) { newValue in
                        let newStatus = newValue ? "approved" : "revoked"
                        if member.status != newStatus {
                            updateData(memberId: member.id, status: newStatus)
                            member.status = newStatus
                        }
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
}

// Main view for displaying members
struct MembersView: View {
    @State private var members: [Member] = []
    @State private var searchText = ""
    private var db = Firestore.firestore()

    var body: some View {
        NavigationView {
            ScrollView {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 320)
                        }
                    )


                LazyVStack(spacing: 16) {
                    ForEach(filteredMembers, id: \.id) { member in
                        MemberCard(member: .constant(member))  // Binding for toggling
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                    }
                }
            }
            .navigationTitle("MEMBERS")
            .onAppear {
                fetchData()
            }
        }
    }

    var filteredMembers: [Member] {
        if searchText.isEmpty {
            return members
        } else {
            return members.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.email.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Fetch data from Firestore
    func fetchData() {
        db.collection("users").whereField("role", isEqualTo: "member")
          .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.members = documents.map { doc -> Member in
                let data = doc.data()
                let email = data["email"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let status = data["status"] as? String ?? ""
                return Member(id: doc.documentID, name: name, email: email, status: status, isToggled: status == "approved")
            }
        }
    }
}

// Preview provider for SwiftUI previews
struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
    }
}
