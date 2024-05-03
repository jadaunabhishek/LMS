//
//  SignupView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var shouldNavigate = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 300, height: 150, alignment: .center)
                
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                HStack{
                    Spacer()
                    
                    Text("*All fields are mandatory")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                }
                
                
                TextField("Name", text: $name)
                    .font(.title3)
                    .padding(12)
                    .autocapitalization(.none)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 5)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                
                TextField("Email Id", text: $email)
                    .font(.title3)
                    .padding(12)
                    .autocapitalization(.none)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 5)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                
                SecureField("Password", text: $password)
                    .font(.title3)
                    .padding(12)
                    .autocapitalization(.none)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 5)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                ZStack{
                    SecureField("Confirm Password", text: $confirmPassword)
                        .font(.title3)
                        .padding(12)
                        .autocapitalization(.words)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
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
                
                Button(action: {
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
                                    let userSchema = UserSchema(userID: userId, name: name, email: email, mobile: "", profileImage: "", role: "user", activeFine: 0, totalFined: 0, penaltiesCount: 0, createdOn: Date.now, updateOn: Date.now, status: "registered")
                                    
                                    let db = Firestore.firestore()
                                    db.collection("users").document(userId).setData(userSchema.getDictionaryOfUserSchema()) { err in
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
                }) {
                    Text("Sign Up")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryColor"))
                        .cornerRadius(50)
                }
                .disabled(email.isEmpty || confirmPassword.isEmpty || password.isEmpty || password != confirmPassword )
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                
                NavigationLink("", destination: LoginView(), isActive: $shouldNavigate)
                    .hidden()
                
                HStack {
                    Button(action: {
                    }) {
                        HStack{
                            Image("google")
                            Text("Sign up with Google")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color("PrimaryColor"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50.0)
                    }
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: LoginView()) {
                        Text("LOG IN")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
            }
            .padding()
            
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    SignupView()
}
