//
//  History.swift
//  Library Management System
//
//  Created by user2 on 09/05/24.
//

import SwiftUI
import FirebaseAuth

struct UserHistory: View {
    @ObservedObject var ConfiViewMmodel = ConfigViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HStack{
                    Text("Borrowed Books History")
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
            .navigationTitle("Your History")
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

#Preview {
    UserHistory(LibViewModel: LibrarianViewModel())
}
