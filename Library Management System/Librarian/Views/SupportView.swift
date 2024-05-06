//
//  SupportView.swift
//  Library Management System
//
//  Created by Admin on 06/05/24.


import SwiftUI

struct SupportView: View {
    @State private var createIssue = false
    @State private var showDetails = false
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                if(!authViewModel.allSupports.isEmpty){
                    ScrollView{
                        VStack{
                            ForEach(0..<authViewModel.allSupports.count, id: \.self) { supportDetail in
                                IssueView(supportData: authViewModel.allSupports[supportDetail])
                            }
                        }
                    }
                }
                else{
                    EmptyPage()
                }
            }
            .listStyle(.inset)
            .background(.black.opacity(0.05))
            .navigationTitle("Support")
            .navigationBarItems(trailing: Button(action: {
                createIssue = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $createIssue, content: {
                CreateIssue()
            })
            .task {
                Task{
                    authViewModel.getSupports()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
            
        }
    }
}



struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return SupportView(authViewModel: AuthViewModel()).environmentObject(themeManager)
    }
}


