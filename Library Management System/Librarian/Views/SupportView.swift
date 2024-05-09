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
            List {
                ForEach(authViewModel.allSupports, id: \.id) { supportData in
                    NavigationLink(destination: SupportResponse(supportData: supportData, authViewModel: authViewModel)) {
                        supportCard(supportData: supportData)
                    }
                }
            }
            .background(Color(.systemGray5))
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

//struct DetailedIssueView: View {
//    var issue: SupportIssue
//    @State private var replyText: String = "" // To hold reply text if needed
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Detailed Description")
//                        .font(.title2)
//                        .bold()
//                        .padding(.bottom, 2)
//
//                    Text(issue.description)
//                        .padding(.bottom, 20)
//
//                    Text("Reply from Librarian:")
//                        .font(.headline)
//                        .padding(.bottom, 2)
//
//                    if let reply = issue.reply {
//                        Text(reply)
//                    } else {
//                        Text("No reply yet...")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding()
//            Spacer()
//        }
//        .padding()
//        .navigationTitle(issue.title) // Adds a navigation title if this view is embedded in a navigation stack
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}


struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return SupportView(authViewModel: AuthViewModel()).environmentObject(themeManager)
    }
}


