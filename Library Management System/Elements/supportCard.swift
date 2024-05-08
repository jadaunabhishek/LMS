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
                        
                        HStack{
                            Text(formatDate(supportData.createdOn))
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack{
                        Text("Subject :")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Text(supportData.Subject)
                            .font(.callout)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Status :")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Text(supportData.status)
                            .font(.callout)
                            .foregroundColor(.black)
                        
                    }
                    .padding(.bottom, 8)
                    Divider()
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal)
            }
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        if let date = dateFormatter.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "dd/MM/yy"
            return dateFormatterOutput.string(from: date)
        } else {
            return "Invalid Date"
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
