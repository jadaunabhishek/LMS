//
//  ContentView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive: Bool = false
    
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
                    .foregroundColor(.white) 
                
                
                Spacer()
                
                Text("One scan for healthy skin!")
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.top, 8)
                 
                NavigationLink(
                    destination: OnboardingView(),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
                .navigationBarTitle("Main Screen", displayMode: .inline)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
                .background(
                    Text("Your App Content")
                )
                .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
