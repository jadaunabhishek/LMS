//
//  TestNotificationView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 03/05/24.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @StateObject var viewModel = NotificationsViewModel()
    @State private var selectedOption: Option = .CheckOut
    @State var searchText = ""
    @State var Bol: Bool = false
    
    enum Option {
        case CheckIn
        case Membership
        case CheckOut
    }
    
    var body: some View {
        NavigationStack{
            VStack(){
                HStack() {
                    
                    PickerButton(title: "Check Out", isSelected: selectedOption == .CheckOut) {
                        self.selectedOption = .CheckOut
                    }
                    
                    PickerButton(title: "Check In", isSelected: selectedOption == .CheckIn) {
                        self.selectedOption = .CheckIn
                    }
                    
                    PickerButton(title: "Membership", isSelected: selectedOption == .Membership) {
                        self.selectedOption = .Membership
                    }
                }
                .padding([.bottom, .leading, .trailing])
//                SearchBar(text: $searchText, isFilterButtonTapped: $Bol, showFilterOptions: $Bol)
                
                if selectedOption == .CheckOut {
                    if LibViewModel.requestedLoans.isEmpty {
                        EmptySection()
                    } else {
                        BooksSections(LibViewModel: LibViewModel)
                    }
                } else {
                    if viewModel.notifications.isEmpty {
                        EmptySection()
                    } else {
                        MembershipSections()
                    }
                }
            }
            
            .onAppear {
                Task{
                    LibViewModel.getLoans()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    viewModel.fetchData()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
        }
        .searchable(text: $searchText)
    }
}



struct EmptySection: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            Text("emptyMessage")
                .foregroundColor(.gray)
                .font(.headline)
                .padding()
                .italic()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct MembershipSections: View {
    
    @StateObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        List {
            ForEach(0..<viewModel.notifications.count, id: \.self) { key in
                MemberRequestCustomBox(viewModel: viewModel, notification: viewModel.notifications[key])
                    .swipeActions(edge: .trailing){
                        
                        Button {
                        } label: {
                            Label("Accept", systemImage: "checkmark")
                        }
                        .tint(.green)
                        
                    }
                    .swipeActions(edge: .leading){
                        
                        Button {
                        } label: {
                            Label("Reject", systemImage: "xmark")
                        }
                        .tint(.red)
                    }
            }
        }
        .listStyle(.inset)
    }
}



struct BooksSections: View {
    @ObservedObject var LibViewModel: LibrarianViewModel
    
    var body: some View {
        List {
            ForEach(0..<LibViewModel.requestedLoans.count, id: \.self) { key in
                    BookRequestCustomBox(bookRequestData: LibViewModel.requestedLoans[key])
                    .swipeActions(edge: .trailing){
                        Button {
                        } label: {
                            Label("Accept", systemImage: "checkmark")
                        }
                        .tint(.green)
                        
                    }
                    .swipeActions(edge: .leading){
                        
                        Button {
                        } label: {
                            Label("Reject", systemImage: "xmark")
                        }
                        .tint(.red)
                    }
            }
        }
        .listStyle(.inset)
    }
}

struct TestNotificationView_Previews: PreviewProvider {
    static var previews: some View {
    let themeManager = ThemeManager()
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()

    return NotificationsView(LibViewModel: LibViewModel)
            .environmentObject(themeManager)
    }
}
