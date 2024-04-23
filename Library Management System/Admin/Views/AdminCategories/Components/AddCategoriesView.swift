//
//  AddCategoriesView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AddCategoriesView: View {
    @Binding var isSheetPresented: Bool
    @State private var newCategoryName = ""
    
    var body: some View {
                    NavigationView {
                        VStack {
                            TextField("Email Id", text: $newCategoryName)
                                .font(.title3)
                                .padding(12)
                                .autocapitalization(.none)
                                .foregroundColor(Color("TextColor"))
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(15)
                                .padding(.horizontal, 5)
                                .padding(.bottom, 5)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            TextField("New Category Name", text: $newCategoryName)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
        
                            Button("Add Category") {
                                // MARK: adding a categories
                                isSheetPresented = false
                            }
                            .padding()
                            .disabled(newCategoryName.isEmpty)
                        }
                        .navigationTitle("Add Category")
                        .navigationBarItems(trailing: Button("Cancel") {
                            isSheetPresented = false
                        })
                    }
                }
    
}
#Preview {
    AddCategoriesView(isSheetPresented: .constant(false))
}
