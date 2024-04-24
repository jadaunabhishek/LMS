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
    @State private var isChecked = false
    @State private var shouldNavigate = false
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Spacer()
                    Spacer()
                    
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 300, height: 150, alignment: .center)
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
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
                    
                    Toggle(isOn: $isChecked) {
                        Text("I have read and accept Terms of Service and Privacy Policy")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: UIFont.systemFontSize))
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    
                    Button(action: {
                        if !email.isEmpty, !confirmPassword.isEmpty, !password.isEmpty,!name.isEmpty, password == confirmPassword, isChecked {
                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    // Handle the login error
                                    print("Error signing up in: \(error.localizedDescription)")
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
                    .disabled(email.isEmpty || confirmPassword.isEmpty || password.isEmpty || password != confirmPassword || !isChecked)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    NavigationLink("", destination: LoginView(), isActive: $shouldNavigate)
                        .hidden() // Hide the navigation link
                    
                    Divider()
                        .padding()
                    
                    HStack {
                        Button(action: {
                        }) {
                            HStack{
                                Image("google")
                            }
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                        }                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 10)
                    }
                }
                .navigationBarHidden(true)
                .padding()
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: LoginView()) {
                        Text("LOG IN")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                .padding([.leading, .trailing])
            }
        }
    }
}
    

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? Color("PrimaryColor") : .gray)
                .onTapGesture { configuration.isOn.toggle() }
            
            configuration.label
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

