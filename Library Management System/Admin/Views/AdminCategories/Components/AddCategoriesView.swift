//
//  AddCategoriesView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AddCategoriesView: View {
    @State private var newCategoryName = ""
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var configViewModel = ConfigViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading){
                    Text("Add Category")
                        .font(.title.bold())
                        .padding()
                        .padding(.bottom,16)
                    CustomTextField(text: $newCategoryName)
                }
                
                PrimaryCustomButton(action: {
                    configViewModel.addCategory(configId: "HJ9L6mDbi01TJvX3ja7Z", categories: addCategories(newCategory:newCategoryName))
                    presentationMode.wrappedValue.dismiss()
                }, label: "Add Category")
                .disabled(newCategoryName.isEmpty)
            }
            .padding()
        }
    }
    
    func addCategories(newCategory: String) -> [String] {
        var newCategoriesList = configViewModel.currentConfig[0].categories
        newCategoriesList.append(newCategory)
        return newCategoriesList
    }
}

struct  AddCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return  AddCategoriesView()
            .environmentObject(themeManager)
    }
}
