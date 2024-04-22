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
                NavigationLink(
                    destination: LoginView(),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
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
        ContentView()
    }
}

