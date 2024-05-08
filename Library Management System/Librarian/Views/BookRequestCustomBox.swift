//
//  BookRequestCustomBox.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 03/05/24.
//

import SwiftUI

struct BookRequestCustomBox: View {
    
    @State var bookRequestData: Loan
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack{
            HStack{
                AsyncImage(url: URL(string: bookRequestData.bookImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80,height: 120)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 5){
                    Spacer()
                    
                    Text("\(bookRequestData.bookName)")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 22, weight: .bold))
                        .lineLimit(2)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    
                    Text(bookRequestData.bookIssuedToName)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 19, weight: .semibold))
                        .lineLimit(1)
                        .foregroundColor(Color(.systemGray))
                    HStack{
                        Image(systemName: "calendar")
                            .font(.system(size: 18,weight: .bold))
                        Text(formatDate(bookRequestData.bookIssuedOn))
                            .font(.system(size: 14, weight: .regular))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                        Text(formatDate(bookRequestData.bookExpectedReturnOn))
                            .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(5)
                Spacer()
                VStack{
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(10)
            .cornerRadius(8)
            .background(Color(.systemGray6).opacity(0.6))
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

