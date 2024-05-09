//
//  AdminCatalogView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminCategoriesView: View {
    
    @State private var searchKey = ""
    @State private var isSheetPresented = false
    @State var isPageLoading: Bool = true
    @ObservedObject var configViewModel: ConfigViewModel
    @ObservedObject var libViewModel: LibrarianViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var filteredCategories: [String] {
        if searchKey.isEmpty {
            return configViewModel.currentConfig[0].categories
        } else {
            return configViewModel.currentConfig[0].categories.filter { $0.localizedCaseInsensitiveContains(searchKey) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if(!isPageLoading){
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(filteredCategories, id: \.self) { category in
                                NavigationLink(destination: AdminSubCategoriesView(category: category, configViewModel: configViewModel, librarianViewModel: libViewModel)) {
                                    VStack(alignment: .leading) {
                                        AdminCategoriesCard(category: category)
                                            .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding()
                }
                else
                {
                    ProgressView()
                }
            }
            .navigationTitle("Categories")
            .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
            .navigationBarItems(leading: Spacer(),trailing:
                                    Button(action: {
                isSheetPresented.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.title3)
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
            }
                .sheet(isPresented: $isSheetPresented) {
                    AddCategoriesView()
                        .presentationDetents([.fraction(0.35)])
                }
            )
        }
        .task {
            do{
                configViewModel.fetchConfig()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                isPageLoading = false
            }
        }
        .searchable(text: $searchKey)
    }
}

struct AdminCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var configViewModel = ConfigViewModel()
        @StateObject var libViewModel = LibrarianViewModel()
        return AdminCategoriesView(configViewModel: configViewModel, libViewModel: libViewModel)
            .environmentObject(themeManager)
    }
}
