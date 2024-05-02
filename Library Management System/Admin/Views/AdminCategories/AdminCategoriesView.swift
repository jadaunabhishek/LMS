//
//  AdminCatalogView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminCategoriesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var configViewModel: ConfigViewModel
    @StateObject var ConfiModel = ConfigViewModel()
    @State private var searchKey = ""
    @State private var isSheetPresented = false
    
    @State var isPageLoading: Bool = true
    var filteredCategories: [String] {
        if searchKey.isEmpty {
            return configViewModel.currentConfig[0].categories
        } else {
            return configViewModel.currentConfig[0].categories.filter { $0.localizedCaseInsensitiveContains(searchKey) }
        }
    }
    var body: some View {
        
        NavigationStack {
            
                VStack(){
                    if(!isPageLoading){
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(filteredCategories, id: \.self) { category in
                                    NavigationLink(destination: AdminSubCategoriesView(configViewModel: ConfigViewModel(), category: category)) {
                                        VStack(alignment: .leading) {
                                            AdminCategoriesCard(category: category)
                                                .foregroundStyle(.black)
                                                
                                        }
                                        
                                    }
                                }
                            }
                            .padding(.bottom,86)
                        }
                        .scrollIndicators(.hidden)
                        .padding()
                    }
                    else{
                        ProgressView()
                    }
                
                }
                .navigationTitle("Categories")
                .navigationBarItems(leading: Spacer(),trailing:
                                        Button(action: {
                                            isSheetPresented.toggle()
                                        }) {
                                            Image(systemName: "plus")
                                                .font(.title3)
                                                .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                        }
                                        .sheet(isPresented: $isSheetPresented, content: {
                                            AddCategoriesView(isSheetPresented: $isSheetPresented, configViewModel: ConfiModel).presentationDetents([.fraction(0.35)])
                                        })
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

struct ACPre: View {
    
    @StateObject var ConfiModel = ConfigViewModel()
    var body: some View {
        AdminCategoriesView(configViewModel: ConfiModel)
    }
}


struct ACPre_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return ACPre()
            .environmentObject(themeManager)
    }
}
