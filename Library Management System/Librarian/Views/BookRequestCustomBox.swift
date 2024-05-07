//
//  BookRequestCustomBox.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 03/05/24.
//

import SwiftUI

struct BookRequestCustomBox: View {
    
    @State var bookRequestData: Loan
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: bookRequestData.bookImageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
                .frame(width: 60, height: 90)
                .padding(.trailing)
            
            VStack(alignment:.leading, spacing: 10){
                
                VStack(alignment: .leading, spacing: 2){
                    Text(bookRequestData.bookIssuedToName)
                        .font(.system(size: 20, weight: .medium))
                    Text(bookRequestData.bookName)
                        .font(.system(size: 16))
                }
                HStack{
                    Image(systemName: "calendar")
                        .font(.system(size: 18,weight: .bold))
                    Text(formatDate(bookRequestData.bookIssuedOn))
                        .font(.system(size: 14, weight: .regular))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                    Text(formatDate(bookRequestData.bookExpectedReturnOn))
                        .font(.system(size: 14, weight: .regular))
                }
            }
            Spacer()
        }
        .padding(.vertical, 10)
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

