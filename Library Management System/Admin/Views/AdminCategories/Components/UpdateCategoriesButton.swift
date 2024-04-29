//
//  UpdateCategoriesButton.swift
//  Library Management System
//
//  Created by admin on 28/04/24.
//

import SwiftUI

struct UpdateCategoriesButton: View {
    @State private var isSheetPresented = false
    @StateObject var ConfiModel = ConfigViewModel()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Button{
                    isSheetPresented.toggle()
                }label:{
                    Image(systemName: "pencil")
                        .padding()
                        .background(.pink)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $isSheetPresented ) {
                
                NavigationView {
                    UpdateCategoriesView(isSheetPresented: $isSheetPresented, configViewModel: ConfiModel)
                        .background(.gray)
                        .navigationBarItems(
                            trailing:  Button(action:{isSheetPresented.toggle()}){
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        )
//                        .environment(\.colorScheme, .dark)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    UpdateCategoriesButton()
}
