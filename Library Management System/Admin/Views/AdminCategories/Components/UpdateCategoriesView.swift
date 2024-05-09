//
//  UpdateCategoryView.swift
//  Library Management System
//
//  Created by admin on 25/04/24.
//

import SwiftUI

struct UpdateCategoriesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isSheetPresented: Bool
    @ObservedObject var configViewModel: ConfigViewModel
    @State private var newCategoryName : String
    @State var category: String
    @State private var selectedCategoryIndex = 0
    @State private var categories: [String] = []
    @State private var isFetchingCategories = true

    init(isSheetPresented: Binding<Bool>, configViewModel: ConfigViewModel, category: String) {
        _isSheetPresented = isSheetPresented
        self.configViewModel = configViewModel
        self._category = State(initialValue: category)
        _newCategoryName = State(initialValue: category)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    CustomTextField(text: $newCategoryName, placeholder: "")
                    Button(action: {
                        deleteCategory()
                    }) {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding(.all ,14)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                
                PrimaryCustomButton(action: {
                    let oldCategoryName = category
                    configViewModel.updateCategory(configId: "HJ9L6mDbi01TJvX3ja7Z", categories: updateCategories(oldCategory: oldCategoryName, newCategory: newCategoryName))
                    isSheetPresented = false

                }, label: "Update Category")
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
    
    func deleteCategory() {
        guard let index = categories.firstIndex(of: category) else {
            return
        }
        categories.remove(at: index)
        
        configViewModel.updateCategory(configId: "HJ9L6mDbi01TJvX3ja7Z", categories: categories)
        isSheetPresented = false
    }

    func updateCategories(oldCategory: String, newCategory: String) -> [String] {
        let newCategoriesList = configViewModel.currentConfig[0].categories.map { $0 == oldCategory ? newCategory : $0 }
        //        newCategoriesList.append(newCategory)
        return newCategoriesList
    }
    
}

struct UCPrev: View {
    
    @StateObject var ConfigrationViewModel = ConfigViewModel()
    
    var body: some View {
        UpdateCategoriesView(isSheetPresented: .constant(false), configViewModel: ConfigrationViewModel, category: "Fantasy")
    }
}

struct UCPrev_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return UCPrev()
            .environmentObject(themeManager)
    }
}
