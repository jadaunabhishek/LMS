//
//  CheckInView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 05/05/24.
//

import SwiftUI

struct CheckInDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var checkInDetails: Loan
    @State var LibViewModel: LibrarianViewModel
    
    var body: some View {
        List {
            Section(header: Text("Member Details")) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                
                HStack{
                    Text("Name: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(checkInDetails.bookIssuedToName)
                        .fontWeight(.semibold)
                }
                
                
                HStack{
                    Text("Role: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("Member")
                        .fontWeight(.semibold)
                }
                
            }
            
            Section(header: Text("Book Information")) {
                
                HStack{
                    Text("Title: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(checkInDetails.bookName)
                        .fontWeight(.semibold)
                }
                
                HStack{
                    Text("Issued on: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatDate(checkInDetails.bookIssuedOn))
                        .font(.subheadline)
                }
                
                HStack{
                    Text("Expected return: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatDate(checkInDetails.bookExpectedReturnOn))
                        .font(.subheadline)
                }
                
                HStack{
                    Text("Status: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(checkInDetails.loanStatus)
                        .font(.subheadline)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(action: {
            Task {
                do {
                    try await LibViewModel.checkInBook(loanId: checkInDetails.loanId, bookId: checkInDetails.bookId)
                    // Handle success
                } catch {
                    // Handle error
                }
            }
        }, label: {
            Text("CheckIn")
        }))
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        if let date = dateFormatter.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "dd/MM/yy"
            return dateFormatterOutput.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

struct CIDVPrev: View {
    
    @State var LibViewModel = LibrarianViewModel()
    let loan = Loan(loanId: "1",
                    bookId: "123",
                    bookName: "Sample Book",
                    bookIssuedTo: "John Doe",
                    bookIssuedToName: "John Doe",
                    bookIssuedOn: "05/01/2024, 10:00 AM",
                    bookExpectedReturnOn: "05/15/2024, 10:00 AM",
                    bookReturnedOn: "05/12/2024, 10:00 AM",
                    loanStatus: "Returned",
                    loanReminderStatus: "None",
                    createdOn: "05/01/2024, 10:00 AM",
                    updatedOn: "05/12/2024, 10:00 AM",
                    timeStamp: 1620202800)
    
    var body: some View {
        CheckInDetailsView(checkInDetails: loan, LibViewModel: LibViewModel)
    }
}

#Preview {
    CIDVPrev()
}


