//
//  ResponseCard.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 07/05/24.
//


import SwiftUI

struct supportCard: View {
    @State var supportData: SupportTicket
    
    var body: some View {
        VStack{
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(supportData.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(supportData.createdOn)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    HStack{
                        Text("Subject :")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Text(supportData.Subject)
                            .font(.callout)
                    }
                    
                    HStack {
                        Text("Status :")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Text(supportData.status)
                            .font(.callout)
                        
                    }
                }
                .padding(5)
                
            }
            .previewLayout(.sizeThatFits)
            .background(Color.white)
            .cornerRadius(10)
            
        }
    }
}


struct supportCard_Previews: PreviewProvider {
    static var previews: some View {
        supportCard(supportData: SupportTicket(
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
        ))
    }
}
