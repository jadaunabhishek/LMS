import SwiftUI
import FirebaseFirestore

struct Member{
    let id: String
    var name: String
    var email: String
    var status: String
    var isToggled: Bool
}

struct MembersView: View {
    @State private var members: [Member] = []
    private var db = Firestore.firestore()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach($members, id: \.id) { $member in
                        MemberCard(member: $member)
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
                if(status == "approved"){
                    return Member(id: doc.documentID, name: name, email: email, status: status, isToggled: true)
                }
                else{
                    return Member(id: doc.documentID, name: name, email: email, status: status, isToggled: false)
                }
            }
        }
    }
}

struct MemberCard: View {
    
    var db = Firestore.firestore()
    
    func updateData(memberId: String, status: String){
        db.collection("users").document(memberId).updateData(["status":status])
    }
    
    @Binding var member: Member

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
                    Text("\(member.email)")
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
                    .onChange(of: member.isToggled, initial: true){ (oldValue,newValue) in
                        if(newValue != oldValue){
                            if(newValue){
                                updateData(memberId: member.id, status: "approved")
                            }
                            else{
                                updateData(memberId: member.id, status: "revoked")
                            }
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

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
    }
}
