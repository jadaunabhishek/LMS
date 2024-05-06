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
