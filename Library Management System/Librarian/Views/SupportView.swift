//
//  SupportView.swift
//  Library Management System
//
//  Created by Admin on 06/05/24.


import SwiftUI

struct SupportView: View {
    @State private var createIssue = false
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(authViewModel.allSupports, id: \.id) { supportData in
                    NavigationLink(destination: SupportResponse(supportData: supportData, authViewModel: authViewModel)) {
                        supportCard(supportData: supportData)
                    }
                }
            }
            .listStyle(.inset)
            .background(Color.black.opacity(0.05))
            .navigationTitle("Support")
            .sheet(isPresented: $createIssue) {
                CreateIssue()
            }
            .task {
                await authViewModel.getSupports()
            }
        }
    }
}



struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return SupportView(authViewModel: AuthViewModel()).environmentObject(themeManager)
    }
}


