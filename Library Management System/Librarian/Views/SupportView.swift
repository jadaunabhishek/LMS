//
//  SupportView.swift
//  Library Management System
//
//  Created by Admin on 06/05/24.
//

import SwiftUI

struct SupportView: View {
    @State private var createIssue = false
    @State private var showDetails = false
    @ObservedObject var authViewModel: AuthViewModel
    
    @State var pageState: String = "Main"
    @State var currentIssue: [SupportTicket] = []
    
    @State var myReply: String = ""
    @State var isEditing: Bool = true
    
    var body: some View {
        NavigationView {
            if(pageState == "Main"){
                List {
                    if(!authViewModel.allSupports.isEmpty){
                        ScrollView{
                            VStack{
                                ForEach(0..<authViewModel.allSupports.count, id: \.self) { supportDetail in
                                    Button(action:{pageState = "Sub"
                                        currentIssue.append(authViewModel.allSupports[supportDetail])}){
                                        IssueView(supportData: authViewModel.allSupports[supportDetail])
                                    }
                                }
                            }
                        }
                    }
                    else{
                        EmptyPage()
                    }
                }
                .listStyle(.inset)
                .background(.black.opacity(0.05))
                .navigationTitle("Support")
                .onAppear(
                    perform: {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
                            Task{
                                authViewModel.getSupports()
                                try? await Task.sleep(nanoseconds: 1_000_000_000)
                            }
                        }
                    }
                )
            }
            else{
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Detailed Description")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 2)

                            Text(currentIssue[0].description)
                                .padding(.bottom, 20)

                            Text("Reply from Librarian:")
                                .font(.headline)
                                .padding(.bottom, 2)

                            if !currentIssue[0].reply.isEmpty {
                                Text(currentIssue[0].reply)
                            } else {
                                CustomTextField(text: $myReply, placeholder: "Enter response")
                                PrimaryCustomButton(action: {
                                    authViewModel.respondSupport(supportId: currentIssue[0].id, response: myReply)
                                }, label: "Send")
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                .padding()
//                .navigationTitle(currentIssue.title) // Adds a navigation title if this view is embedded in a navigation stack
//                .navigationBarTitleDisplayMode(.inline)
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
