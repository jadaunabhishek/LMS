//
//  AddBookPage.swift
//  Library Management System
//
//  Created by Rishichaary S on 23/04/24.
//

import SwiftUI

struct AddBookPage: View {
    var body: some View {
        VStack{
            HStack{
                Button( action:{} ){
                    Image(systemName: "")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 18, weight: .medium))
                }
                Spacer()
                Text("Add Bok")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
}

#Preview {
    AddBookPage()
}
