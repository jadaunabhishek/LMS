//
//  Records.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 07/05/24.
//

import SwiftUI
import FirebaseAuth

struct Records: View {
    @State private var searchText = ""
    @ObservedObject var ConfiViewMmodel = ConfigViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @State var isPageLoading: Bool = true
    @State var searchContent = ""
    @ObservedObject var LibViewModel: LibrarianViewModel
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                HStack{
                    Text("Fines")
                    Spacer()
                }
                .foregroundStyle(Color(.systemGray3))
                .padding(.horizontal)
                .fontWeight(.bold)
                .padding(.bottom, -5)
                
                if(!LibViewModel.currentUserOverDueHistory.isEmpty){
                    HStack {
                        ForEach(0..<LibViewModel.currentUserOverDueHistory.count, id: \.self) { userDetail in
                            NavigationLink(destination: RecordBookDetail(checkInDetails: LibViewModel.currentUserOverDueHistory[userDetail], LibViewModel: LibViewModel)){
                                BookFineBox(bookRequestData: LibViewModel.currentUserOverDueHistory[userDetail])
                            }
                        }
                    }
                } else {
                    EmptySection()
                }
                
                
                HStack{
                    Text("Request Pending")
                    Spacer()
                }
                .foregroundStyle(Color(.systemGray3))
                .padding(.horizontal)
                .fontWeight(.bold)
                .padding(.bottom, -5)
                
                if(!LibViewModel.currentUserHistory.isEmpty){
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<LibViewModel.currentUserHistory.count, id: \.self) { userDetail in
                                NavigationLink(destination: RecordBookDetail(checkInDetails: LibViewModel.currentUserHistory[userDetail], LibViewModel: LibViewModel)){
                                    BookReqBox(bookRequestData: LibViewModel.currentUserHistory[userDetail])
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                } else {
                    EmptySection()
                }
                
                
                
                HStack{
                    Text("Borrowed Books")
                    Spacer()
                }
                .foregroundStyle(Color(.systemGray3))
                .padding(.horizontal)
                .fontWeight(.bold)
                .padding(.bottom, -5)
                
                if(!LibViewModel.currentUserProperHistory.isEmpty){
                    VStack {
                        ForEach(0..<LibViewModel.currentUserProperHistory.count, id: \.self) { userDetail in
                            NavigationLink(destination: RecordBookDetail(checkInDetails: LibViewModel.currentUserProperHistory[userDetail], LibViewModel: LibViewModel)){
                                BookRequestCustomBox(bookRequestData: LibViewModel.currentUserProperHistory[userDetail])
                            }
                        }
                    }
                } else {
                    EmptySection()
                }
            }
            .searchable(text: $searchContent)
            .navigationTitle("Records")
            .task{
                Task{
                    if let userID = Auth.auth().currentUser?.uid {
                        LibViewModel.getUserHistory(userId: userID)
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        print(LibViewModel.currentUserHistory)
                    }
                }
            }
        }
    }
}


struct Records_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        let librarianViewModel = LibrarianViewModel()
        
        // Creating sample data for preview
        let sampleBookRequest = Loan(
            loanId: "1",
            bookId: "123",
            bookName: "Sample Book",
            bookImageURL: "sample_image_url",
            bookIssuedTo: "user123",
            bookIssuedToName: "John Doe",
            bookIssuedOn: "2024-05-01",
            bookExpectedReturnOn: "2024-05-15",
            bookReturnedOn: "",
            loanStatus: "Issued",
            loanReminderStatus: "Pending",
            fineCalculatedDays: 0,
            loanFine: 0,
            createdOn: "2024-05-01",
            updatedOn: "2024-05-07",
            timeStamp: 20393939202
        )
        
        // Adding sample data to the librarianViewModel
        librarianViewModel.currentUserHistory = [sampleBookRequest]
        
        return Records(LibViewModel: librarianViewModel)
            .environmentObject(themeManager)
    }
}


//struct RecordsPrev: View {
//    @StateObject var memModelView = UserBooksModel()
//    @StateObject var ConfiViewModel = ConfigViewModel()
//    @StateObject var LibMod = LibrarianViewModel()
//    @State private var searchText = ""
//    var body: some View {
//        Records(LibViewModel: LibMod)
//    }
//}
//
//struct Records_Previews: PreviewProvider {
//    static var previews: some View {
//        let themeManager = ThemeManager()
//        return RecordsPrev()
//            .environmentObject(themeManager)
//    }
//}

