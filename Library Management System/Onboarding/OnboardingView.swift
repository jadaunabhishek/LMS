import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    let texts = ["We're thrilled to have you join our library community.", "Easily check out books, manage loans, and prebook items—all at your fingertips.", " From bestsellers to academic journals, we've got it all."]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<3) { index in // Use integer literals directly
                    VStack {
                        Image("onboardingImage\(index + 1)")
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                        
                        Text(texts[index])
                            .padding(.top, 10)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
//            VStack {
//                PrimaryCustomButton(action: {
//                    // Action for "Agree & Join" button
//                }, label: "Get Started")
//            }.padding()
            VStack {
                PrimaryCustomButton(action: {
                    // Action for "Agree & Join" button
                }, label: "Agree & Join")
                
                
                SignupCustomButton(action: {
                    print("Login Attempt")
                    
                }, label: "Sign Up with Google",imageName: "google")
                
                
                Button(action: {
                    // Action for "Sign In" button
                }) {
                    Text("Sign In")
                        .font(.title3)
                        .padding()
                        .foregroundColor(.blue)
                }
            }
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
