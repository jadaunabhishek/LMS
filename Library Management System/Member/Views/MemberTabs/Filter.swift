

import SwiftUI


struct Filter: View {
    @State private var searchText = ""
    @State private var isFilterButtonTapped = false
    @State private var showFilterOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, isFilterButtonTapped: $isFilterButtonTapped, showFilterOptions: $showFilterOptions)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            .navigationTitle("Search")
            .sheet(isPresented: $showFilterOptions) {
                FilterOptions()
                    .presentationDetents([.medium])
            }
            
            
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isFilterButtonTapped: Bool
    @Binding var showFilterOptions: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            TextField("Search", text: $text)
            
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.trailing, 8)
            HStack {
                Button(action: {
                    
                    isFilterButtonTapped.toggle()
                    showFilterOptions.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
                .padding(.trailing, 8)
                .onTapGesture {
                    isFilterButtonTapped.toggle()
                    showFilterOptions.toggle()
                }
            }
        }
    }
}

struct FilterOptions: View {
    @State private var selectedCategories: [String] = []
    @State private var selectedAuthors: [String] = []
    @State private var selectedLanguages: [String] = []
    
    let categories = ["Fiction", "Non-Fiction", "Science Fiction", "Mystery", "Thriller", "Romance", "Fantasy", "Biography", "Self-Help"]
    let authors = ["Harward Business review", "Darren Hardy", "Ed haddon"]
    let languages = ["English", "Hindi", "French", "German", "Chinese"]
    
    var body: some View {
        
        VStack (alignment: .leading){
            Spacer()
            Section(header: Text("Category")) {
                ScrollView(.horizontal){
                    HStack{
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                if selectedCategories.contains(category) {
                                    selectedCategories.removeAll(where: { $0 == category })
                                } else {
                                    selectedCategories.append(category)
                                }
                            }) {
                                Text(category)
                                    .padding()
                                    .foregroundColor(selectedCategories.contains(category) ? .white : .black)
                                    .background(selectedCategories.contains(category) ? Color.blue : Color.gray.opacity(0.3))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(.trailing, 8)
                        }
                    }
                }
                
            }
            
            Divider()
            
            Section(header: Text("Author")) {
                ScrollView(.horizontal){
                    HStack{
                        ForEach(authors, id: \.self) { author in
                            Button(action: {
                                if selectedAuthors.contains(author) {
                                    selectedAuthors.removeAll(where: { $0 == author })
                                } else {
                                    selectedAuthors.append(author)
                                }
                            }) {
                                Text(author)
                                    .padding()
                                    .foregroundColor(selectedAuthors.contains(author) ? .white : .black)
                                    .background(selectedAuthors.contains(author) ? Color.blue : Color.gray.opacity(0.3))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(.trailing, 8)
                        }
                    }
                }
            }
            
            Divider()
            
            Section(header: Text("Language")) {
                ScrollView(.horizontal){
                    HStack {
                        ForEach(languages, id: \.self) {language in
                            Button(action: {
                                if selectedLanguages.contains(language) {
                                    selectedLanguages.removeAll(where: { $0 == language })
                                } else {
                                    selectedLanguages.append(language)
                                }
                            }) {
                                Text(language)
                                    .padding()
                                    .foregroundColor(selectedLanguages.contains(language) ? .white : .black)
                                    .background(selectedLanguages.contains(language) ? Color.blue : Color.gray.opacity(0.3))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(.trailing, 8)
                        }
                    }
                }
            }
            
            Divider()
            
            
        }
        .padding(.all, 15)
        Button(action: {
            print("Selected Categories: \(selectedCategories)")
            print("Selected Authors: \(selectedAuthors)")
            print("Selected Languages: \(selectedLanguages)")
        }) {
            Text("Apply")
                .padding(.vertical, 10)
                .padding(.horizontal, 150)
                .background(Color.blue) // Blue background color
                .foregroundColor(.white) // White text color
                .cornerRadius(20) // Rounded corners
        }
        .padding(.bottom, 25)
    }
}

#Preview {
        Filter()
}

