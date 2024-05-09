import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentPage = 0
    @State var naviToRegister = false
    @State var naviToLogin = false
    @State var naviToGoogleLogin = false
    
    let texts = ["We're thrilled to have you join our library community.", "Easily check out books, manage loans, and prebook items—all at your fingertips.", " From bestsellers to academic journals, we've got it all."]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<3) { index in
                    VStack {
                        Image("onboardingImage\(index + 1)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
                            .tag(index)
                        
                        Text(texts[index])
                            .padding()
                            .multilineTextAlignment(.center)
                            .font(.title2)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 1.5)
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            VStack {
                PrimaryCustomButton(action: {
                    naviToRegister = true
                    UserDefaults.standard.set(true, forKey: "onBoarded")
                }, label: "Agree & Join")
                
                
                SignupCustomButton(action: {
                    FireAuth.share.signInWithGoogle(presenting: getRootViewController()){
                        error in
                        print("ERROR: \(error)")
                    }
                    print("Google Login Attempt")
                    UserDefaults.standard.set(true, forKey: "onBoarded")
                    
                }, label: "Continue with Google",imageName: "google")
                
                
                Button(action: {
                    naviToLogin = true
                    UserDefaults.standard.set(true, forKey: "onBoarded")
                }) {
                    Text("Sign In")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                }
                
                NavigationLink(
                    destination: LoginView(),
                    isActive: $naviToLogin
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: SignupView(),
                    isActive: $naviToRegister
                ) {
                    EmptyView()
                }
            }
            .frame(height: UIScreen.main.bounds.height / 3)
            .padding()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            withAnimation {
                currentPage = (currentPage + 1) % 3
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        OnboardingView()
            .environmentObject(themeManager)
    }
}
