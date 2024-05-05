//
//  LibrarianHomeView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 05/05/24.
//

import SwiftUI

struct LibrarianHomeView: View {
    var body: some View {
        NavigationView{
            Text("Hello, World!")
                .navigationTitle("Home")
        }
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LibrarianHomeView()
}
