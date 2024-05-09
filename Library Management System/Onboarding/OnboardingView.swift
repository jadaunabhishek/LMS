import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentPage = 0
    
    let texts = ["We're thrilled to have you join our library community.", "Easily check out books, manage loans, and prebook items—all at your fingertips.", " From bestsellers to academic journals, we've got it all."]
    
    var body: some View {
        VStack {
            HStack{
                
            }
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
                }, label: "Agree & Join")
                
                
                SignupCustomButton(action: {
                    print("Login Attempt")
                    
                }, label: "Continue with Google",imageName: "google")
                
                
                Button(action: {
                    // Action for "Sign In" button
                }) {
                    Text("Sign In")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                }
            }
            .frame(height: UIScreen.main.bounds.height / 3)
            .padding()
        }
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
