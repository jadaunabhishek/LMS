//
//  SupportView.swift
//  Library Management System
//
//  Created by Admin on 06/05/24.


import SwiftUI

struct SupportView: View {
    @State private var createIssue = false
    @ObservedObject var authViewModel: AuthViewModel
    
    @State var pageState: String = "Main"
    @State var currentIssue: [SupportTicket] = []
    
    @State var myReply: String = ""
    @State var isEditing: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                if(!authViewModel.allSupports.isEmpty){
                    ForEach(authViewModel.allSupports, id: \.id) { supportData in
                        NavigationLink(destination: SupportResponse(supportData: supportData, authViewModel: authViewModel)) {
                            supportCard(supportData: supportData)
                        }
                    }
                }
                else {
                    EmptyPage()
                }
                Spacer()
            }            .navigationTitle("Support")
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


