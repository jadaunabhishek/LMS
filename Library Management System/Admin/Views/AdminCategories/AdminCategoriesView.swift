//
//  AdminCatalogView.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminCategoriesView: View {
    
    let books: [Bok] = [
        Bok(id: 1, isbn: "978-0-553-57340-4", name: "The Great Adventure", author: "Emily Smith", description: "A thrilling adventure novel filled with mystery and excitement.", publishingDate: "2023-05-15", category: "Fiction", subcategory: "Action", status: "Available"),
        Bok(id: 2, isbn: "978-0-439-02348-6", name: "Secrets of the Lost City", author: "John Johnson", description: "An archaeological thriller uncovering the secrets of an ancient civilization.", publishingDate: "2022-09-20", category: "Fiction", subcategory: "Mystery", status: "Available"),
        Bok(id: 3, isbn: "978-0-06-288180-3", name: "The Art of Cooking", author: "Linda Martinez", description: "A comprehensive guide to mastering the culinary arts.", publishingDate: "2023-02-10", category: "Non-Fiction", subcategory: "Cookbooks", status: "Available"),
        Bok(id: 4, isbn: "978-0-306-40615-7", name: "The Universe Within", author: "David Thompson", description: "Exploring the mysteries of the cosmos and the human mind.", publishingDate: "2023-08-28", category: "Non-Fiction", subcategory: "Science", status: "Available"),
        Bok(id: 5, isbn: "978-0-307-95614-7", name: "The Silent Observer", author: "Rachel Green", description: "A gripping psychological thriller that will keep you on the edge of your seat.", publishingDate: "2023-11-05", category: "Fiction", subcategory: "Thriller", status: "Available"),
        Bok(id: 6, isbn: "978-0-553-57289-6", name: "The Lost Kingdom", author: "Michael Brown", description: "An epic fantasy tale of magic, betrayal, and redemption.", publishingDate: "2023-07-12", category: "Fiction", subcategory: "Fantasy", status: "Available"),
        Bok(id: 7, isbn: "978-0-006-33616-6", name: "The Hidden Power", author: "Andrew Wilson", description: "Unleash your hidden potential with this insightful self-help guide.", publishingDate: "2023-04-18", category: "Non-Fiction", subcategory: "Self-Help", status: "Available"),
        Bok(id: 8, isbn: "978-0-006-28756-8", name: "Beyond the Horizon", author: "Jessica Turner", description: "Embark on a journey of discovery with this captivating travel memoir.", publishingDate: "2023-09-30", category: "Non_Naan", subcategory: "Travel", status: "Available"),
        Bok(id: 9, isbn: "978-0-553-57338-1", name: "Echoes of the Past", author: "Jessica Turner", description: "A heartwarming story of love, loss, and second chances.", publishingDate: "2022-12-15", category: "Fiction", subcategory: "Romance", status: "Available"),
        Bok(id: 10, isbn: "978-0-553-57290-2", name: "The Code Breaker", author: "Mark Johnson", description: "The gripping true story of one woman's quest to unlock the secrets of the human genome.", publishingDate: "2023-04-25", category: "Non-Fiction", subcategory: "Science", status: "Available"),
        Bok(id: 11, isbn: "978-0-553-57341-1", name: "The Last Stand", author: "Robert Johnson", description: "A gripping tale of survival against all odds.", publishingDate: "2023-06-20", category: "Fiction", subcategory: "Adventure", status: "Available"),
        Bok(id: 12, isbn: "978-0-439-02349-3", name: "The Phantom Thief", author: "Emily Parker", description: "Join a master thief on a high-stakes heist.", publishingDate: "2023-01-10", category: "Fiction", subcategory: "Crime", status: "Available"),
        Bok(id: 13, isbn: "978-0-06-288181-0", name: "The Science of Nutrition", author: "Michael Adams", description: "Explore the latest research on diet and health.", publishingDate: "2023-10-15", category: "Non-Fiction", subcategory: "Health & Nutrition", status: "Available"),
        Bok(id: 14, isbn: "978-0-306-40616-4", name: "Beyond the Stars", author: "Jennifer Lee", description: "A breathtaking journey through the cosmos.", publishingDate: "2022-11-12", category: "Non-Fiction", subcategory: "Cosmology", status: "Available"),
        Bok(id: 15, isbn: "978-0-307-95615-4", name: "The Ghost Writer", author: "David Smith", description: "An enigmatic ghostwriter becomes embroiled in a web of secrets.", publishingDate: "2023-03-08", category: "Fiction", subcategory: "Suspense", status: "Available"),
        Bok(id: 16, isbn: "978-0-553-57291-9", name: "The Power of Now", author: "Eckhart Tolle", description: "Discover the keys to living in the present moment.", publishingDate: "2023-08-05", category: "Non-Fiction", subcategory: "Spirituality", status: "Available"),
        Bok(id: 17, isbn: "978-0-006-33617-3", name: "The Lost City of Atlantis", author: "Timothy Roberts", description: "Unravel the mystery of the legendary lost civilization.", publishingDate: "2023-07-01", category: "Non-Fiction", subcategory: "History", status: "Available"),
        Bok(id: 18, isbn: "978-0-553-57342-8", name: "The Time Traveler's Dilemma", author: "Jessica Turner", description: "A mind-bending journey through time and space.", publishingDate: "2022-12-28", category: "Fiction", subcategory: "Science Fiction", status: "Available"),
        Bok(id: 19, isbn: "978-0-553-57292-6", name: "The Healing Power of Nature", author: "Sarah Johnson", description: "Connect with the natural world to enhance your well-being.", publishingDate: "2023-05-30", category: "Veg", subcategory: "Holistic Health", status: "Available"),
        Bok(id: 20, isbn: "978-0-553-57343-5", name: "The Enigma of Existence", author: "John White", description: "Contemplate the profound mysteries of existence.", publishingDate: "2023-09-18", category: "Non-Veg", subcategory: "Philosophy", status: "Available")
    ]
    @State private var searchKey = ""
    var body: some View {
    
        NavigationStack {
            VStack(){
                Rectangle()
                    .fill(.red)
                    .frame(height: 80)
                    .cornerRadius(5)
                
                TextField("what are u looking for?", text: $searchKey)
                    .foregroundStyle(.black)
                    
                    .padding(14)
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                        
                    }
                .padding(.horizontal,34)
                .padding(.top,20)
                Image(systemName: "magnifyingglass")
                    .offset(x:130,y:-35)
                Spacer()
                            let groupedBooks = Dictionary(grouping: books, by: { $0.category })
                            
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(groupedBooks.keys.sorted(), id: \.self) { category in
                            NavigationLink(destination:AdminSubCategoriesView(groupedBooks: groupedBooks[category]!)) {
                                VStack(alignment: .leading) {
                                    AdminCategoriesCard(category: category)
                                        .foregroundStyle(.black)
                                }
                                .padding(.horizontal)
                            }
                                        
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .ignoresSafeArea(.all)
        }
        .overlay(
            AddCategories()
                .position(CGPoint(x: 350.0, y: 680.0))
        )
    }
}


#Preview {
    AdminCategoriesView()
}


struct Bok: Identifiable {
    let id: Int
    let isbn: String
    let name: String
    let author: String
    let description: String
    let publishingDate: String
    let category: String
    let subcategory: String
    let status: String
}
