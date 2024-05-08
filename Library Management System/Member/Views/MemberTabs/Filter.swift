//
//
//import SwiftUI
//
//struct SearchBar: View {
//    @Binding var text: String
//    var body: some View {
//        VStack{
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.gray)
//                    .padding(.leading, 8)
//                TextField("Search", text: $text)
//                    .padding(8)
//                    .background(Color(.systemGray5))
//                    .cornerRadius(8)
//                
//            }
//            .background(Color(.systemGray5))
//            .cornerRadius(8)
//        }
//
//    }
//}
//
//
//struct Filter: View {
//    @State private var selectedCategories: [String] = []
//    @State var selectedAuthors: [String] = []
//    @State var userBooksModel: UserBooksModel
//    var authors: [String] {
//        userBooksModel.authors
//    }
//    
//    @State private var searchText = ""
//    @ObservedObject var MemBooksModel = UserBooksModel()
//    @State private var filteredBooks: [Book] = []
//    let categories = ["Fiction", "Non-Fiction", "Science Fiction", "Mystery", "Thriller", "Romance", "Fantasy", "Biography", "Self-Help"]
//    
//    var body: some View {
//
//            VStack {
//                SearchBar(text: $searchText)
//                    .padding(.top, 16)
//                    .padding(.horizontal, 10)
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(categories, id: \.self) { category in
//                                Button(action: {
//                                    if selectedCategories.contains(category) {
//                                        selectedCategories.removeAll(where: { $0 == category })
//                                    } else {
//                                        selectedCategories.append(category)
//                                    }
//                                }) {
//                                    Text(category)
//                                        .padding(8)
//                                        .foregroundColor(selectedCategories.contains(category) ? .white : .black)
//                                        .background(selectedCategories.contains(category) ? Color.blue : Color.gray.opacity(0.3))
//                                        .overlay(
//                                            Rectangle()
//                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                                        )
//                                }
//                                .padding(.trailing, 8)
//                            }
//                        }.padding(.horizontal)
//                    }
//                    .padding(.top, 16)
//                }
//                
//                Spacer()
//            .navigationTitle("Search")
//    }
//}
//
//#Preview {
//    Filter(userBooksModel: UserBooksModel())
//}
