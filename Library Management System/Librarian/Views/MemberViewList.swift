import SwiftUI
import FirebaseFirestore

struct Member {
    let id: String
    var name: String
    var email: String
    var status: String
    var profileImgURL: String
    var isToggled: Bool
}

struct MemberCard: View {
    var db = Firestore.firestore()
    var member: Member
    @EnvironmentObject var themeManager: ThemeManager
    
    func updateData(memberId: String, status: String) {
        db.collection("users").document(memberId).updateData(["status": status])
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: member.profileImgURL)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .font(.headline)
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .frame(width: 60, height: 60)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle()).foregroundStyle(themeManager.selectedTheme.secondaryThemeColor)
            .padding(.trailing)
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.headline)
                Text(member.email)
                    .font(.subheadline)
                
                Text("Status: \(member.status)")
                    .font(.subheadline)
                
            }
            Spacer()
        }
        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
    }
}

struct MembersView: View {
    @State private var members: [Member] = []
    @State private var searchText = ""
    @EnvironmentObject var themeManager: ThemeManager
    
    var db = Firestore.firestore()
    func updateData(memberId: String, status: String) {
        db.collection("users").document(memberId).updateData(["status": status])
    }
    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(filteredMembers, id: \.id) { member in
                        MemberCard(member: member)
                            .frame(maxWidth: .infinity)
                            .swipeActions(edge: .trailing){
                                if(member.status != "approved"){
                                    Button(action:{
                                        updateData(memberId: member.id, status: "approved")
                                        fetchData()
                                        
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
                    let status = data["status"] as? String ?? ""
                    let profileImgURL = data["profileImage"] as? String ?? ""
                    return Member(id: doc.documentID, name: name, email: email, status: status, profileImgURL: profileImgURL, isToggled: status == "approved")
                }
            }
    }
}

struct MembersView_Previews: PreviewProvider {
    
    static var previews: some View {
        let themeManager = ThemeManager()
        MembersView().environmentObject(themeManager)
    }
}
