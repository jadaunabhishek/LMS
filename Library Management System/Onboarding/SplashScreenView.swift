import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            // Background color or image
            themeManager.selectedTheme.secondaryThemeColor// Change to your desired background color
            
            // Your logo or branding
            VStack {
                            Image("appLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200) // Adjust size as needed
                            
                            Text("Trove")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white) // Adjust text color
                        }
        }
        .edgesIgnoringSafeArea(.all) // Ignore safe area edges to cover full screen
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        SplashScreenView()
            .environmentObject(themeManager)
    }
}
