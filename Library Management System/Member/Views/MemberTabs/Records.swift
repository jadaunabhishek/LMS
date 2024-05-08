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
            List {
                ForEach(0..<LibViewModel.currentUserHistory.count, id: \.self) { userDetail in
                    NavigationLink(destination: RecordBookDetail(checkInDetails: LibViewModel.currentUserHistory[userDetail], LibViewModel: LibViewModel)){
                        BookRequestCustomBox(bookRequestData: LibViewModel.currentUserHistory[userDetail])
                    }
                }
            }
            .listStyle(.inset)
            
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

struct RecordsPrev: View {
    @StateObject var memModelView = UserBooksModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    @StateObject var LibMod = LibrarianViewModel()
    @State private var searchText = ""
    var body: some View {
        Records(LibViewModel: LibMod)
    }
}

struct Records_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return RecordsPrev()
            .environmentObject(themeManager)
    }
}

