//
//  AdminStaffView.swift
//  Library Management System
//
//  Created by Ishan Joshi on 22/04/24.
//

import SwiftUI

struct StaffSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct AdminStaffView: View {
    @State private var isAddStaffViewPresented = false
    @State private var searchText = ""
    @StateObject var staffViewModel = StaffViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var filteredStaff: [Staff] {
        if searchText.isEmpty {
            return staffViewModel.currentStaff
        } else {
            return staffViewModel.currentStaff.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    if !filteredStaff.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(filteredStaff, id: \.userID) { staffMember in
                                NavigationLink(destination: StaffDetailsView(staffMember: staffMember)) {
                                    HStack {
                                        AsyncImage(url: URL(string: staffMember.profileImageURL)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .font(.headline)
                                                .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .frame(width: 60, height: 60)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle()).foregroundStyle(themeManager.selectedTheme.secondaryThemeColor)
                                        
                                        VStack(alignment: .leading) {
                                            Text(staffMember.name)
                                                .font(.headline)
                                                .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                                            
                                            Text(staffMember.email)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }.padding(.leading, 20)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(themeManager.selectedTheme.bodyTextColor.opacity(0.5))
                                    }.padding()
                                }
                                
                            }.padding(.horizontal)
                        }.navigationBarTitle("Manage Staff")
                        
                    } else {
                        Text("No staff members found.")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationBarItems(leading: Spacer(),trailing:
                                        Button(action: {
                    isAddStaffViewPresented.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                }
                )
                .sheet(isPresented: $isAddStaffViewPresented) {
                    AddStaffView()
                        .presentationDetents([.fraction(0.85)])
                }
                .onAppear{
                    staffViewModel.getStaff()
                }
            }.searchable(text: $searchText)
        }
    }
}

struct AdminStaffView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminStaffView()
            .environmentObject(themeManager)
    }
}
