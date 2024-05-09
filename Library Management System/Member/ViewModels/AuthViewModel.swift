import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var shouldNavigate = false
    @Published var shouldNavigateToAdmin = false
    @Published var shouldNavigateToLibrarian = false
    @Published var shouldNavigateToMember = false
    @Published var shouldNavigateToGeneral = false
    @Published var userName = ""
    @Published var userEmail = ""
    @Published var userID = ""
    @Published var allSupports: [SupportTicket] = []
    @Published var allUsers: [UserSchema] = []
    @Published var totalIncome: Int = 0
    @Published var finesPending: Int = 0
    

    @Published var appliedUsers: Int = 0
    @Published var rejectedUsers: Int = 0
    @Published var approvedUsers: Int = 0
    @Published var newUsers: Int = 0
    
    private var db = Firestore.firestore()
    
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle the login error
                print("Error logging in: \(error.localizedDescription)")
            } else {
                // Login was successful, check for user role
                print("Login successful!")
                UserDefaults.standard.set(true, forKey: "emailLoggedIn")
                UserDefaults.standard.set(email, forKey: "email")
                // Assume the UID is used as the document ID in `users` collection
                self?.fetchUserRole(email: email)
            }
        }
    }
    
    func fetchAllUsers(){
        var tempAllUsers: [UserSchema] = []
        var temtTotalFines: Int = 0
        var totalFinesPending: Int = 0
        var tempAppliedUsers: Int = 0
        var tempRejectedUsers: Int = 0
        var tempApprovedUsers: Int = 0
        var tempNewUsers: Int = 0
        
        self.db.collection("users").whereField("role", isEqualTo: "member").getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                    
                    let tempUser = UserSchema(userID: documentData["userID"] as! String as Any as! String, name: documentData["name"] as! String as Any as! String, email: documentData["email"] as! String as Any as! String, mobile: documentData["mobile"] as! String as Any as! String, profileImage: documentData["profileImage"] as! String as Any as! String, role: documentData["role"] as! String as Any as! String, activeFine: documentData["activeFine"] as! Int as Any as! Int, totalFined: documentData["totalFined"] as! Int as Any as! Int, penaltiesCount: documentData["penaltiesCount"] as! Int as Any as! Int, createdOn: Date.now, updateOn: Date.now, status: documentData["status"] as! String as Any as! String)
                    
                    totalFinesPending += tempUser.activeFine
                    temtTotalFines += tempUser.totalFined
                    
                    tempAllUsers.append(tempUser)
                    
                    if tempUser.status == "applied" {
                        tempAppliedUsers += 1
                    }
                    if tempUser.status == "approved" {
                        tempApprovedUsers += 1
                    }
                    if tempUser.status == "new" {
                        tempNewUsers += 1
                    }
                    if tempUser.status == "rejected" {
                        tempRejectedUsers += 1
                    }
                }
                
                self.totalIncome = temtTotalFines
                self.finesPending = totalFinesPending
                self.allUsers = tempAllUsers
                
                self.appliedUsers = tempAppliedUsers
                self.approvedUsers = tempApprovedUsers
                self.newUsers = tempNewUsers
                self.rejectedUsers = tempRejectedUsers
            }
        }
    }
    
    
    func fetchUserRole(email: String) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching user by email: \(error.localizedDescription)")
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                print("No documents found or role not found")
                return
            }
            
            let role = document.data()["role"] as? String ?? ""
            let id = document.data()[""]
            // Check role and navigate based on it
            DispatchQueue.main.async {
                // Implement role-based navigation logic
                self?.navigateBasedOnRole(role: role)
            }
        }
    }
    
    
    func addSupportTicket(userID: String, name: String, email: String, message: String, subject: String) {
        
        let isSupportIssue = message.contains("support")
        let addNewRequest = self.db.collection("Support").document()
        
        let newRequest = SupportTicket(id: addNewRequest.documentID, senderID: userID, name: name, email: email,description: message, status: "Pending", handledBy: "", createdOn: Date.now.formatted(), updatedOn: Date.now.formatted(), reply: "", LibName: "", Subject: subject)
        
        // Choose the collection based on whether it's a support issue
        addNewRequest.setData(newRequest.getDeict()){ error in
            if let error = error{
                print("Issue in creating Ticket")
            }
            else{
                print("Tickect created successfully")
            }
        }
    }
    
    func respondSupport(supportId: String, response: String){
        
        db.collection("Support").document(supportId).updateData(["reply":response,"status":"Completed"]){ error in
            if let error = error{
                print("Error")
            }
            else{
                print("Done")
            }
        }
        
    }
    
    func getSupport(){
        
        guard let userID = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
        print(userID)
        var tempSupports: [SupportTicket] = []
        
        dbInstance.collection("Support").whereField("senderID", isEqualTo: userID).getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                
                    let support = SupportTicket(id: documentData["id"] as! String as Any as! String, senderID: documentData["senderID"] as! String as Any as! String, name: documentData["name"] as! String as Any as! String, email: documentData["email"] as! String as Any as! String, description:  documentData["description"] as! String as Any as! String, status: documentData["status"] as! String as Any as! String, handledBy: documentData["handledBy"] as! String as Any as! String, createdOn: documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, reply: documentData["reply"] as! String as Any as! String, LibName: documentData["LibName"] as! String as Any as! String, Subject: documentData["Subject"] as! String as Any as! String)
                    tempSupports.append(support)
                }
                self.allSupports = tempSupports
                print(tempSupports)
            }
            else{
                print("Error")
            }
            
        }
        
    }
    
    func getSupports(){
        
        var tempSupports: [SupportTicket] = []
        
        dbInstance.collection("Support").getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                
                    let support = SupportTicket(id: documentData["id"] as! String as Any as! String, senderID: documentData["senderID"] as! String as Any as! String, name: documentData["name"] as! String as Any as! String, email: documentData["email"] as! String as Any as! String, description:  documentData["description"] as! String as Any as! String, status: documentData["status"] as! String as Any as! String, handledBy: documentData["handledBy"] as! String as Any as! String, createdOn: documentData["createdOn"] as! String as Any as! String, updatedOn: documentData["updatedOn"] as! String as Any as! String, reply: documentData["reply"] as! String as Any as! String, LibName: documentData["LibName"] as! String as Any as! String, Subject: documentData["Subject"] as! String as Any as! String)
                    tempSupports.append(support)
                }
                self.allSupports = tempSupports
                print("From BE: ",tempSupports)
            }
            else{
                print("Error")
            }
            
        }
        
    }
    
    
    
    
    func fetchUserData(userID: String) {
        db.collection("users").document(userID).getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("User document not found")
                return
            }
            
            // Extract user data from the document
            let userData = document.data()
            self!.userEmail = userData?["email"] as? String ?? ""
            self!.userName = userData?["name"] as? String ?? ""
            self!.userID = userID
            
            // Do something with the retrieved user data
            print("User email: \(self!.userEmail), name: \(self!.userName)")
            
            // Example: Update UI or perform further actions based on user data
            DispatchQueue.main.async {
                // Update UI or perform further actions
            }
        }
    }
    
    
    private func navigateBasedOnRole(role: String){
        // Implement your role-based navigation here
        // For example:
        print(role)
        DispatchQueue.main.async {
            switch role {
            case "admin":
                self.shouldNavigateToAdmin = true
            case "librarian":
                self.shouldNavigateToLibrarian = true
            case "member":
                self.shouldNavigateToMember = true
            default:
                self.shouldNavigateToGeneral = true
            }
        }
    }
    
    func findAndUpdateUserStatus(email: String, newStatus: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(false)
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("User not found")
                completion(false)
                return
            }
            
            let documentID = document.documentID
            
        }
    }
}
