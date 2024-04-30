//
//  AdminStaffView.swift
//  Library Management System
//
//  Created by Ishan on 22/04/24.
//

import SwiftUI

struct AdminStaffView: View {
    @State private var isAddStaffViewPresented = false
    @StateObject var staffViewModel = StaffViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    if !staffViewModel.currentStaff.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(staffViewModel.currentStaff, id: \.userID) { staffMember in
                                NavigationLink(destination: StaffDetailsView(staffMember: staffMember)) {
                                    HStack {
                                        AsyncImage(url: URL(string: staffMember.profileImageURL)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        .frame(width: 60, height: 60)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        
                                        VStack(alignment: .leading) {
                                            Text(staffMember.name)
                                                .font(.headline)
                                                .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                                            
                                            Text(staffMember.email)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }.padding(.leading, 20)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                                    }.padding()
                                }
                                
                            }.padding(.horizontal)
                        }
                        
                    } else {
                        Text("No staff members found.")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationBarTitle("Manage Staff")
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
            }
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
