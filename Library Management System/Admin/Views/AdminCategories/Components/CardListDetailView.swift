//
//  CardListDetailView.swift
//  Library Management System
//
//  Created by admin on 23/04/24.
//

import SwiftUI

struct CardListDetailView: View {
    
    var books: [Book]
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                VStack{
                    ForEach(books.indices, id: \.self) { index in
                        VStack{
                            NavigationLink(destination:BookDetailView(LibViewModel: LibrarianViewModel(), ConfiViewModel: ConfigViewModel(), currentBookId: books[index].id)){
                                HStack(){
                                    AsyncImage(url: URL(string: books[index].bookImageURL)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60,height: 80)
                                    .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("\(books[index].bookName)")
                                            .font(.system(size: 18, weight: .bold))
                                        Text("\(books[index].bookAuthor)")
                                            .font(.system(size: 18, weight: .regular))
                                    }
                                    .padding(5)
                                    Spacer()
                                    VStack{
                                        Image(systemName: "chevron.right")
                                            .symbolRenderingMode(.hierarchical)
                                            .font(.system(size: 25))
                                    }
                                }
                                .padding(10)
                                .background(.white)
                                .cornerRadius(8)
                            }
                            .foregroundColor(.black)
                            
                        }
                        
                        
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
    
}
#Preview {
    CardListDetailView(books:[])
}
