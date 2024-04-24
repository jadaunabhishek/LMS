//
//  AdminStaffView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI

struct AdminStaffView: View {
    @State private var isAddStaffViewPresented = false
    @StateObject var staffViewModel = StaffViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack {
                if !staffViewModel.currentStaff.isEmpty {
                    List(staffViewModel.currentStaff, id: \.userID) { staffMember in
                        VStack(alignment: .leading) {
                            Text(staffMember.name)
                                .font(.headline)
                            Text(staffMember.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                } else {
                    Text("No staff members found.")
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    isAddStaffViewPresented.toggle()
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(themeManager.selectedTheme.primaryThemeColor)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                        .clipShape(Circle())
                }
                .padding()
            }
            .navigationBarTitle("Manage Staff")
            .navigationBarBackButtonHidden()
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

struct AdminStaffView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminStaffView()
            .environmentObject(themeManager)
    }
}
