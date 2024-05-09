//
//  ContentView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive: Bool = false
    @AppStorage("onBoarded") var onBoarded = false
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed
                
                Text("Trove")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                
                
                Spacer()
                
                Text("One scan for healthy skin!")
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.top, 8)
                
                if onBoarded {
                    NavigationLink(
                        destination: OnboardingView(),
                        isActive: $isActive
                    ) {
                        EmptyView()
                    }
                } else {
                    NavigationLink(
                        destination: LoginView(),
                        isActive: $isActive
                    ) {
                        EmptyView()
                    }
                }
            }
            
            .navigationBarTitle("Main Screen", displayMode: .inline)
            .onAppear {
                Task{
                    await themeManager.setBaseTheme()
                    self.isActive = true
                }
            }
            .navigationBarHidden(true)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
