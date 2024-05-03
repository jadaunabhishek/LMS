//
//  SignupView.swift
//  Library Management System
//
//  Created by Ishan Joshi on 22/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var shouldNavigate = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 300, height: 150, alignment: .center)
                
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                
                HStack{
                    Spacer()
                    
                    Text("*All fields are mandatory")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                }
                
                LoginTextField(text: $name, placeholder: "Name")
                
                LoginTextField(text: $email, placeholder: "E-mail Id")
                
                SecTextField(text: $password, placeholder: "Password")
                
                ZStack{
                    SecTextField(text: $confirmPassword, placeholder: "Confirm Password")
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.green)
                                .offset(x: 150)
                        }else{
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.red)
                                .offset(x: 150)
                        }
                    }
                }
                .padding(.bottom)
                
                PrimaryCustomButton(action: {
                    if !email.isEmpty, !confirmPassword.isEmpty, !password.isEmpty,!name.isEmpty, password == confirmPassword {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                // Handle the login error
                                print("Error signing up in: \(error.localizedDescription)")
                                
                                self.showAlert = true
                                
                            } else {
                                // If login is successful, navigate to UserFirstView
                                print("Signup successful!")
                                
                                
                                if let userId = authResult?.user.uid {
                                    let db = Firestore.firestore()
                                    db.collection("users").document(userId).setData([
                                        "email": email,
                                        "role": "user",
                                        "name": name,
                                        "status" : "registered"
                                    ]) { err in
                                        if let err = err {
                                            print("Error setting user data: \(err.localizedDescription)")
                                        } else {
                                            print("User data including role set successfully")
                                        }
                                    }
                                }
                                
                                shouldNavigate = true
                            }
                        }
                    }
                    
                }, label: "Sign Up")
                .disabled(email.isEmpty || confirmPassword.isEmpty || password.isEmpty || password != confirmPassword )
                
                
                NavigationLink("", destination: LoginView(), isActive: $shouldNavigate)
                    .hidden()
                
                HStack {
                    
                    SignupCustomButton(action: {
                        print("Login Attempt")
                        
                    }, label: "Sign Up with Google",imageName: "google")
                    
                    
                }
                
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: LoginView()) {
                        Text("LOG IN")
                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                    }
                }
            }
            .padding()
            
        }
        .navigationBarHidden(true)
    }
}



struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return SignupView()
            .environmentObject(themeManager)
    }
}

