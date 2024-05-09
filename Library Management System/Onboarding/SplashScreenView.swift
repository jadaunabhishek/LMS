import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            // Background color or image
            themeManager.selectedTheme.secondaryThemeColor
            VStack {
                            Image("appLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                            
                            Text("Trove")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        SplashScreenView()
            .environmentObject(themeManager)
    }
}
