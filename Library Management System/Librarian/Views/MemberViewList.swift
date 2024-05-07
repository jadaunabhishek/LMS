import SwiftUI
import FirebaseFirestore


struct Member {
    let id: String
    var name: String
    var email: String
    var status: String
    var isToggled: Bool
}


struct MemberCard: View {
    var db = Firestore.firestore()
    @Binding var member: Member

    
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
                    Text("Status: \(member.status)")
                        .font(.subheadline)
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
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding()
    }
}


struct MembersView: View {
    @State private var members: [Member] = []
    @State private var searchText = ""
    
    var db = Firestore.firestore()
    func updateData(memberId: String, status: String) {
        db.collection("users").document(memberId).updateData(["status": status])
    }

    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(filteredMembers, id: \.id) { member in
                        MemberCard(member: .constant(member))
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .swipeActions(edge: .trailing){
                                if(member.status != "Approved"){
                                    Button(action:{
                                        updateData(memberId: member.id, status: "Approved")
                                        fetchData()
                                        //member.status = "Approved"
                                    }){
                                        Label("Approve", systemImage: "checkmark")
                                    }
                                    .tint(.green)
                                }
                                else{
                                    Button(action:{
                                        updateData(memberId: member.id, status: "Revoked")
                                        fetchData()
                                    }){
                                        Label("Revoke", systemImage: "xmark")
                                    }
                                    .tint(.red)
                                }
                            }
                    }
                }
                .listStyle(.plain)

            }
            .searchable(text: $searchText)
            .navigationTitle("Members")
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
                var status = data["status"] as? String ?? ""
                return Member(id: doc.documentID, name: name, email: email, status: status, isToggled: status == "Approved")
            }
        }
    }
}

    
struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
    }
}
