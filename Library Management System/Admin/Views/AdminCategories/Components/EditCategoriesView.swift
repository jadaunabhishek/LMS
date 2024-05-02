//
//  EditCategoriesView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI
struct EditCategoriesView: View {
    @Binding var isSheetPresented: Bool
    @State private var editCategoryName = ""
    
    var body: some View {
                    NavigationView {
                        VStack(alignment: .leading) {
                            TextField("Edit Category", text: $editCategoryName)
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
                                Text("Edit Categories")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("PrimaryColor"))
                                    .cornerRadius(15)
                            }
                            .padding()
                            .disabled(editCategoryName.isEmpty)
                        }
                        .padding()
                        .navigationTitle("Edit Category")
                        
                    }
                }
    
}
#Preview {
    EditCategoriesView(isSheetPresented: .constant(false))
}

