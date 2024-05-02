//
//  AddCategoriesView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AddCategoriesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isSheetPresented: Bool
    @ObservedObject var configViewModel: ConfigViewModel
    @State private var newCategoryName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack{
                    Text("Add Category")
                        .font(.title.bold())
                        .padding()
                        .padding(.bottom,16)
                    CustomTextField(text: $newCategoryName)
                   
                }
                PrimaryCustomButton(action: {
                    configViewModel.addCategory(configId: "HJ9L6mDbi01TJvX3ja7Z", categories: addCategories(newCategory:newCategoryName))
                    isSheetPresented = false
                    
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

struct ACPrev: View {
    
    @StateObject var ConfigrationViewModel = ConfigViewModel()
    
    var body: some View {
        AddCategoriesView(isSheetPresented: .constant(false), configViewModel: ConfigrationViewModel)
    }
}

struct  ACPrev_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return  ACPrev()
            .environmentObject(themeManager)
    }
}
