//
//  CardListView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct CardListView: View {
    
    var books: [Bok]

    var body: some View {
        
        ScrollView(.horizontal){
            HStack{
                ForEach(books.indices, id: \.self) { index in
                    ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(12)
                                    .padding(.vertical,6)
                                Text(books[index].name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                    
                            .frame(maxWidth: .infinity, alignment: .center)
                            .offset(y: index > 0 ? CGFloat(index) * 50 : 0)
                        }
            }
        }
    }
}

#Preview {
    CardListView(books: [])
}
