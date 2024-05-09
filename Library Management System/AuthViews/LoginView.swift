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
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var configViewModel = ConfigViewModel()
    @StateObject var memModelView = UserBooksModel()
    @StateObject var staffViewModel = StaffViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var shouldNavigate: Bool = false
    @State private var isForgetSheetPresented: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack {
                    if let logoURL = configViewModel.currentConfig.first?.logo {
                        AsyncImage(url: URL(string: logoURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 270, height: 120)
                            default:
                                Image("AppLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 270, height: 120)
                            }
                        }
                    } else {
                        Image("AppLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 150)
                    }
                    
                    Text("Sign In")
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
                    
                    CustomTextField(text: $email, placeholder: "E-mail")
                    
                    SecTextField(text: $password, placeholder: "Password")
                    
                    Text("Forgot your password?")
                        .font(.caption)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
                        .onTapGesture {
                            isForgetSheetPresented.toggle()
                        }
                        .sheet(isPresented: $isForgetSheetPresented) {
                            forgotPasswordView()
                                .presentationDetents([.fraction(0.52)])
                        }
                    
                    
                    PrimaryCustomButton(action: {
                        print("Login Attempt")
                        authViewModel.login(email: email, password: password)
                        print($authViewModel.shouldNavigateToAdmin)
                        
                    }, label: "Log In")
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    NavigationLink(destination: AdminTabView(LibViewModel: LibViewModel, staffViewModel: staffViewModel, userAuthViewModel: authViewModel, configViewModel: configViewModel), isActive: $authViewModel.shouldNavigateToAdmin) { EmptyView() }
                    NavigationLink(destination: LibrarianFirstScreenView(LibModelView: LibViewModel, ConfiViewModel: configViewModel), isActive: $authViewModel.shouldNavigateToLibrarian) { EmptyView() }
                    NavigationLink(destination: MemberTabView(memModelView: memModelView, ConfiViewModel: configViewModel, LibViewModel: LibViewModel, authViewModel: authViewModel), isActive: $authViewModel.shouldNavigateToMember) { EmptyView() }
                    NavigationLink(destination: Membership(memModelView: memModelView, ConfiViewModel: configViewModel, LibViewModel: LibViewModel, authViewModel: authViewModel), isActive: $authViewModel.shouldNavigateToGeneral) { EmptyView() }
                }
                
                .padding()
                
                Spacer()
                
                HStack{
                    Text("Don't have an account?")
                    NavigationLink(destination: SignupView()){
                        Text("REGISTER NOW")
                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                    }
                }
                .padding()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .task {
                    LibViewModel.getBooks()
                }
            }
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


struct forgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    var body: some View {
        
        VStack(alignment: .center){
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray4))
                .frame(width: 100,height: 5)
                .padding()
            VStack(alignment:.leading, spacing: 18) {
               
                   
                Text("Forgot password")
                    .font(.title)
                    .bold()
                VStack(alignment:.leading,spacing:8){
                    
                    Text("You will recive a mail to reset the password.")
                }
                
                VStack(spacing:8){
                    ZStack{
                        CustomTextField(text: $email, placeholder: "Email")
                            .frame(alignment: .leading)
                        if !email.isEmpty {
                            if isValidEmail(email) {
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
                    PrimaryCustomButton(action: {
                        if isValidEmail(email) {
                            Task{
                                try? await resetPassword(email: email)
                            }
                            dismiss()
                        }
                    }, label: "Reset Password")
                    .disabled(!isValidEmail(email))
                }
            }
            .padding(.vertical,40)
            .padding()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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


struct forgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return forgotPasswordView()
            .environmentObject(themeManager)
    }
}

