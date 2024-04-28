//
//  UpdateCategoryView.swift
//  Library Management System
//
//  Created by admin on 25/04/24.
//

import SwiftUI

struct UpdateCategoriesView: View {
    
    @Binding var isSheetPresented: Bool
    @ObservedObject var configViewModel: ConfigViewModel
    @State private var newCategoryName = ""
    //
    @State private var selectedCategoryIndex = 0
    @State private var categories: [String] = []
    @State private var isFetchingCategories = true

    
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                if isFetchingCategories {
                    ProgressView()
                } else {
                    Picker(selection: $selectedCategoryIndex, label: Text("Select a Category")) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index])
                        }
                    }
                    .font(.title3)
                    .padding(12)
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                
                
                
                
                
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
                    Task{
                        let oldCategoryName = categories[selectedCategoryIndex]
                        configViewModel.updateCategory(configId: "HJ9L6mDbi01TJvX3ja7Z", categories: updateCategories(oldCategory: oldCategoryName, newCategory: newCategoryName))
                        isSheetPresented = false
                    }
                } label: {
                    Text("Update Category")
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
            .navigationTitle("Update Category")
            .onAppear {
                fetchCategories()
            }
            
        }
    }
    
    
    func fetchCategories() {
        if !configViewModel.currentConfig.isEmpty {
            categories = configViewModel.currentConfig[0].categories
            isFetchingCategories = false
        }
    }
    
    
    func updateCategories(oldCategory: String, newCategory: String) -> [String] {
        var newCategoriesList = configViewModel.currentConfig[0].categories.map { $0 == oldCategory ? newCategory : $0 }
        //        newCategoriesList.append(newCategory)
        return newCategoriesList
    }
    
}

struct UCPrev: View {
    
    @StateObject var ConfigrationViewModel = ConfigViewModel()
    
    var body: some View {
        UpdateCategoriesView(isSheetPresented: .constant(false), configViewModel: ConfigrationViewModel)
    }
}

#Preview {
    UCPrev()
}
