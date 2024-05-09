//
//  MemberCategoryListView.swift
//  Library Management System
//
//  Created by admin on 09/05/24.
//

import SwiftUI

struct MemberCategoryListView: View {
    
        @ObservedObject var LibViewModel: LibrarianViewModel
        @State private var searchKey = ""
        @State private var isSheetPresented = false
        @State var isPageLoading: Bool = true
        @ObservedObject var configViewModel: ConfigViewModel
        @EnvironmentObject var themeManager: ThemeManager
        
        var filteredCategories: [String] {
            if searchKey.isEmpty {
                return configViewModel.currentConfig[0].categories
            } else {
                return configViewModel.currentConfig[0].categories.filter { $0.localizedCaseInsensitiveContains(searchKey) }
            }
        }
        
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let newwidth = screenWidth * 0.43
        let newheight = screenWidth * 0.35
        NavigationStack{
            VStack{
                if(!isPageLoading){
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(filteredCategories, id: \.self) { category in
                                NavigationLink(destination: MemberCategoryView(category: category, configViewModel: configViewModel, librarianViewModel: LibViewModel)) {
                                    VStack(alignment: .leading) {
                                        ZStack(alignment:.leading){
                                            Rectangle()
                                                .fill(themeManager.randomColor())
                                                .cornerRadius(12)
                                            
                                            VStack(alignment:.leading){
                                                Spacer()
                                                Text(category)
                                                    .font(.title3)
                                                    .lineLimit(1)
                                                    .multilineTextAlignment(.leading)
                                                    .truncationMode(.tail)
                                                    .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                                                    .padding()
                                            }
                                        }
                                        .frame(width: newwidth, height: newheight)
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
            }.searchable(text: $searchKey)
                .task {
                    do{
                        configViewModel.fetchConfig()
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        isPageLoading = false
                    }
                }
                .navigationTitle("Categories")
                .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
        }
        
    }
}

struct MemberCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var configViewModel = ConfigViewModel()
        @StateObject var libViewModel = LibrarianViewModel()
        return MemberCategoryListView(LibViewModel: LibrarianViewModel(), configViewModel: configViewModel)
            .environmentObject(themeManager)
    }
}
