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
                            TextField("New Category Name", text: $newCategoryName)
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
        
                            Button{
                                // MARK: Function Calling
                                isSheetPresented = false
                            } label: {
                                Text("Add Categories")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("PrimaryColor"))
                                    .cornerRadius(15)
                            }
                            .padding()
                            .disabled(newCategoryName.isEmpty)
                        }
                        .padding()
                        .navigationTitle("Add Category")
                        
                    }
                }
    
}
#Preview {
    AddCategoriesView(isSheetPresented: .constant(false))
}
