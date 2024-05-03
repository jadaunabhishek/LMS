//
//  LoginView.swift
//  Library Management System
//
//  Created by Ishan Joshi on 22/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    private var db = Firestore.firestore()
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = AuthViewModel()
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewMOdel = ConfigViewModel()
    @StateObject var memModelView = UserBooksModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var shouldNavigate: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack {
                    
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 300, height: 150, alignment: .center)
                    
                    Text("Log In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                        .padding(.top)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    
                    HStack{
                        Spacer()
                        
                        Text("*All fields are mandatory")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                    }
                    LoginTextField(text: $email, placeholder: "E-mail ")
                    SecTextField(text: $password, placeholder: "Password")

                    
                    Button {
                        Task{
                            try? await resetPassword(email: email)
                        }
                    } label: {
                        Text("Forgot your password?")
                            .font(.caption)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .foregroundStyle(themeManager.selectedTheme.secondaryThemeColor)
                    }
                    
                    PrimaryCustomButton(action: {
                        print("Login Attempt")
                        viewModel.login(email: email, password: password)
                        print($viewModel.shouldNavigateToAdmin)

                    }, label: "Log In")
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    
                    
                    
                    
                    
                    NavigationLink(destination: AdminTabView(), isActive: $viewModel.shouldNavigateToAdmin) { EmptyView() }
                    NavigationLink(destination: LibrarianFirstScreenView(LibModelView: LibViewModel, ConfiViewModel: ConfiViewMOdel), isActive: $viewModel.shouldNavigateToLibrarian) { EmptyView() }
                    NavigationLink(destination: MemberTabView(memModelView: memModelView, ConfiViewModel: ConfiViewMOdel), isActive: $viewModel.shouldNavigateToMember) { EmptyView() }
                    NavigationLink(destination: Membership(), isActive: $viewModel.shouldNavigateToGeneral) { EmptyView() }
                    
                    
                }.padding()
                
                Spacer()
                
                HStack{
                    Text("Don't have an account?")
                    NavigationLink(destination: SignupView()){
                        Text("REGISTER NOW")
                            .foregroundColor(themeManager.selectedTheme.secondaryThemeColor)
                    }
                }
                .padding([.leading, .trailing, .top])
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .task {
                    LibViewModel.getBooks()
                }
                
            }
        }
    }
    func resetPassword(email: String) async throws {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Password updated")
            } catch let error as NSError {
                print("error")
                throw error
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return LoginView()
            .environmentObject(themeManager)
    }
}

