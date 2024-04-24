//
//  AdminStaffView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI

struct AdminStaffView: View {
    @State private var isAddStaffViewPresented = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack {
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
                .padding(.bottom, 16)
            }
            .navigationBarTitle("Admin Staff")
        }
        .sheet(isPresented: $isAddStaffViewPresented) {
            NavigationView {
                AddStaffView()
                    .navigationBarItems(leading: Button("Cancel") {
                        isAddStaffViewPresented.toggle()
                    })
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
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
