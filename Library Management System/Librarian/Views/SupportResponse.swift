//
//  SupportResponse.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 06/05/24.
//

import SwiftUI

struct SupportResponse: View {
    @State var supportData: SupportTicket
    @State var reply: String = ""
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("Member Details")) {
                    HStack {
                        Text("Name ")
                            .foregroundColor(.gray)
                        Text(supportData.name)
                    }
                    
                    HStack {
                        Text("Email ")
                            .foregroundColor(.gray)
                        Text(supportData.email)
                    }
                                        
                    HStack {
                        Text("Subject ")
                            .foregroundColor(.gray)
                        Text(supportData.Subject)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Description ")
                            .foregroundColor(.gray)
                            .padding(.bottom, 1)
                        Text(supportData.description)
                    }
                }
                
                if supportData.status == "Completed"{
                    Section(header: Text("Response")) {
                        Text(supportData.reply)
                    }
                } else {
                    Section(header: Text("Response")) {
                        TextEditor(text: $reply)
                            .frame(minHeight: 100)
                    }
                }
            }
            .navigationBarTitle("Query details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
                authViewModel.respondSupport(supportId: supportData.id, response: reply)
            }) {
                Text("Save")
                    .foregroundColor(.blue)
            }
                .disabled(supportData.status == "Completed")
            )
            
            Spacer()
        }
    }
    
    // Function to determine color based on ticket status
    private func colorForStatus(_ status: String) -> Color {
        switch status {
        case "Resolved":
            return Color.green
        case "Pending":
            return Color.orange
        default:
            return Color.gray
        }
    }
}


struct SupportResponse_Previews: PreviewProvider {
    static var previews: some View {
        @State var authViewModel = AuthViewModel()
        
        SupportResponse(supportData: SupportTicket(
            id: "123456",
            senderID: "user123",
            name: "John Doe",
            email: "john.doe@example.com",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            status: "Pending",
            handledBy: "admin",
            createdOn: "2024-05-07",
            updatedOn: "2024-05-07",
            reply: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            LibName: "Library X",
            Subject: "Issue with book checkout"
        ), authViewModel: authViewModel)
    }
}


