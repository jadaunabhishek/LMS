//
//  Membership.swift
//  Library Management System
//
//  Created by Ishan Joshi on 22/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


struct Membership: View {
    enum MembershipStatus {
        case applied
        case rejected
        case approved
        case new
    }
    
    
    @State private var status_sent: MembershipStatus = .new
    @State private var status_received: MembershipStatus = .new
    @State private var shouldNavigate = false
    private var db = Firestore.firestore()
    @State private var requestStatus = "Request Status"
    @StateObject var ConfiViewMOdel = ConfigViewModel()
    @StateObject var memModelView = UserBooksModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    
    private func colorForStatus(_ status: MembershipStatus) -> Color {
        switch status {
        case .applied:
            return .green
        case .new:
            return .gray
        case .approved:
            return .green
        case .rejected:
            return .red
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack {
                    Rectangle()
                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .frame(height: 250)
                        .navigationBarItems(trailing: Button {
                            UserDefaults.standard.set("false", forKey: "emailLoggedIn")
                            UserDefaults.standard.set("false", forKey: "signIn")
                            let firebaseAuth = Auth.auth()
                            do {
                              try firebaseAuth.signOut()
                            } catch let signOutError as NSError {
                              print("Error signing out: %@", signOutError)
                            }
                            
                        } label: {
                            Text("Log out")
                                .foregroundColor(Color.red)
                        })
                    
                    VStack( spacing: 10) {
                        Text("Membership Access")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Unlock Priority Access")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }.padding(.top, 80)
                        .foregroundColor(.white)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("What's Included")
                            .font(.headline)
                            .padding(.bottom, 5)
                        HStack {
                            Image(systemName: "clock")
                            Text("3-4 weeks duration")
                        }
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Access to Resources")
                        }
                        HStack {
                            Image(systemName: "star")
                            Text("Gets Priority Access")
                        }
                        HStack {
                            Image(systemName: "globe")
                            Text("24/7: Explore Anytime")
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("User")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("-")
                        Text("-")
                        Text("-")
                        Text("-")
                    }
                    
                    VStack{
                        Text("Member")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("✓")
                        Text("✓")
                        Text("✓")
                        Text("✓")
                    }
                }
                .padding()
                HStack{
                    Text("Request Status")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                HStack{
                    
                    VStack(alignment: .leading){
                        HStack{
                            statusIndicator(imageName: "clock", text: "Request Sent", status: status_sent)
                        }
                        Rectangle()
                            .fill(Color(.systemGray))
                            .frame(width: 3, height: 50)
                            .padding(.leading,10)
                        HStack{
                            statusIndicator(imageName: "clock", text: "Request Received by Librarian", status: status_sent)
                            
                        }
                        
                        Rectangle()
                            .fill(Color(.systemGray))
                            .frame(width: 3, height: 50)
                            .padding(.leading,10)
                        HStack{
                            statusIndicator(imageName: "clock", text: requestStatus, status: status_received)
                        }
                        
                    }.padding(.trailing, 60)
                    
                }.padding(.vertical)
                VStack {
                    Spacer()
                    PrimaryCustomButton(action: {
                        self.status_sent = .applied
                        self.status_received = .new
                        self.requestStatus = "Request Status"
                        updateCurrentUserDetails()
                    }, label: "Request Membership")
                    .padding(.bottom, 15)
                    
                    NavigationLink("", destination: MemberTabView(themeManager: themeManager, memModelView: memModelView, ConfiViewModel: ConfiViewMOdel), isActive: $shouldNavigate)
                        .hidden()
                    
                }.padding()
            }
        }
        .onAppear(perform: {
            Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { time in
                fetchCurrentUserDetails()
            }
        })
        
        .ignoresSafeArea(.all)
    }
    private func statusIndicator(imageName: String, text: String, status: MembershipStatus) -> some View {
        HStack {
            Circle()
                .fill(colorForStatus(status))
                .frame(width: 20, height: 20)
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .padding(.trailing, 25)
            Text(text)
        }
        
    }
    
    //fetch current user details
    private func updateCurrentUserDetails() {
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
    
                db.collection("users").document(userId).updateData(["status": "applied"]) { error in
                    if let error = error {
                        print("Error updating user status: \(error.localizedDescription)")
                    } else {
                        print("User status updated successfully")
                    }
                }
                self.status_sent =  .applied
            print("No authenticated user")
        }
    }
    
    //fetch current user details
    private func fetchCurrentUserDetails() {
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
            
            db.collection("users").document(userId).getDocument { [self] (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching user details: \(error.localizedDescription)")
                    return
                }
                
                guard let document = documentSnapshot, document.exists else {
                    print("User document not found")
                    return
                }
                
                if let userData = document.data(),
                   let status = userData["status"] as? String {
//                    print(status)
                    DispatchQueue.main.async {
                        switch status {
                        case "approved":
                            self.status_received = .approved
                            self.requestStatus = "Request Approved"
                            self.status_sent =  .applied
                            self.shouldNavigate = true
                        case "rejected":
                            self.status_received = .rejected
                            self.shouldNavigate = false
                            self.requestStatus = "Request Rejected"
                            self.status_sent = .applied
                        case "applied":
                            self.status_received = .new
                            self.shouldNavigate = false
                            self.requestStatus = "Request Status"
                            self.status_sent = .applied
                        default:
                            self.status_received = .new
                            self.shouldNavigate = false
                            self.requestStatus = "Request Status"
                            self.status_sent = .new
                        }
                    }
                }
            }
        } else {
            print("No authenticated user")
        }
    }

}


struct Membership_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return Membership()
            .environmentObject(themeManager)
    }
}
