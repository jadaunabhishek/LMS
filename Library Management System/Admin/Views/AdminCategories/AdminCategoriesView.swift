//
//  AdminCatalogView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminCategoriesView: View {
    @ObservedObject var configViewModel: ConfigViewModel
    @State private var searchKey = ""
    
    @State var isPageLoading: Bool = true
    
    var body: some View {
    
        NavigationStack {
            VStack(){
                if(!isPageLoading){
                    Rectangle()
                        .fill(.red)
                        .frame(height: 80)
                        .cornerRadius(5)
                        .padding(.bottom)
//                    TextField("what are u looking for?", text: $searchKey)
//                        .foregroundStyle(.black)
//                        
//                        .padding(14)
//                        .background{
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.black, lineWidth: 1)
//                            
//                        }
//                    .padding(.horizontal,34)
//                    .padding(.top,20)
//                    Image(systemName: "magnifyingglass")
//                        .offset(x:130,y:-35)
                    Spacer()
                    
    //                let groupedBooks = Dictionary(grouping: books, by: { $0.category })
                                
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            if(!configViewModel.currentConfig[0].categories.isEmpty){
                                ForEach(configViewModel.currentConfig[0].categories, id: \.self) { category in
                                    NavigationLink(destination:AdminSubCategoriesView(category: category)) {
                                        VStack(alignment: .leading) {
                                            AdminCategoriesCard(category: category)
                                                .foregroundStyle(.black)
                                        }
                                        .padding(.horizontal)
                                    }
        //
        //                            .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                else{
                    Text("Loading........")
                }
            }
            .ignoresSafeArea(.all)
            
        }
        .task {
            do{
                configViewModel.fetchConfig()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                isPageLoading = false
            }
        }
        
        .overlay(
            AddCategories()
                .position(CGPoint(x: 350.0, y: 680.0))
        )
    }
}

struct ACPre: View {
    
    @StateObject var ConfiModel = ConfigViewModel()
    var body: some View {
        AdminCategoriesView(configViewModel: ConfiModel)
    }
}

#Preview {
    ACPre()
        
}


struct Bok: Identifiable {
    let id: Int
    let isbn: String
    let name: String
    let author: String
    let description: String
    let publishingDate: String
    let category: String
    var subcategory: String
    let status: String
}
