import SwiftUI

struct UserProfileView: View {
    @State var userName = ""
    @State var userEmail = ""
    @State var userMobile = ""
    @State var selectedRole: String = "librarian"
    
    @State var selectedImage: UIImage = UIImage()
    @State var isShowingImagePicker = false
    @State var isImageSelected = false
    
    @State var showSuccessAlert = false
    @State var isEditing = false  // State to track editing mode
    
    @State private var selectedCategories: [String: [String]] = [:] // Stores selected subcategories for each category
    
    let bookCategories = [
        "Fiction": ["Science Fiction", "Fantasy", "Thriller", "Romance"],
        "Non-Fiction": ["Biography", "History", "Self-help", "Education"]
    ]
    
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                profileImageSection
                userDetailsSection
                if isEditing {
                    categoriesSection
                }
                if !isEditing {
                    signOutButton
                }
                Spacer()
            }
            .navigationTitle("User Profile")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if isEditing {
                        Button("Cancel") {
                            isEditing = false
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Done") {
                            isEditing = false
                            updateUser()
                        }
                    } else {
                        Button("Edit") {
                            isEditing = true
                        }
                    }
                }
            }
            .alert(isPresented: $showSuccessAlert, content: successAlert)
            .sheet(isPresented: $isShowingImagePicker, content: {
                ImagePicker(selectedImage: $selectedImage, isImageSelected: $isImageSelected, sourceType: .photoLibrary)
            })
            .padding()
        }
    }

    private var profileImageSection: some View {
        Button(action: {
            if isEditing {
                isShowingImagePicker.toggle()
            }
        }) {
            if isImageSelected {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }

    private var userDetailsSection: some View {
        Group {
            TextFieldComponent(placeholder: "Name", text: $userName, isEditing: $isEditing)
            TextFieldComponent(placeholder: "Email", text: $userEmail, isEditing: $isEditing)
            TextFieldComponent(placeholder: "Mobile Number", text: $userMobile, isEditing: $isEditing)
            if !isEditing {
                Text("Role: \(selectedRole)")
                    .padding()
            }
        }
        .padding()
    }

    private var categoriesSection: some View {
        List {
            ForEach(bookCategories.keys.sorted(), id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(bookCategories[category]!, id: \.self) { subCategory in
                        Toggle(subCategory, isOn: .init(
                            get: { selectedCategories[category]?.contains(subCategory) ?? false },
                            set: { isSelected in
                                if isSelected {
                                    if selectedCategories[category] != nil {
                                        selectedCategories[category]!.append(subCategory)
                                    } else {
                                        selectedCategories[category] = [subCategory]
                                    }
                                } else {
                                    selectedCategories[category]?.removeAll(where: { $0 == subCategory })
                                }
                            }
                        ))
                    }
                }
            }
        }
    }

    private var signOutButton: some View {
        Button("Sign Out") {
            // Implement your sign-out logic here
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red)
        .cornerRadius(10)
    }

    private func updateUser() {
        print("User details updated successfully!")
        print("Selected Categories: \(selectedCategories)")
        showSuccessAlert = true
    }

    private func successAlert() -> Alert {
        Alert(title: Text("Success"), message: Text("Profile Updated Successfully!"), dismissButton: .default(Text("OK")) {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        UserProfileView()
            .environmentObject(themeManager)
    }
}
