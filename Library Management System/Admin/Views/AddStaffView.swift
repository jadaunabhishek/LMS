//
//  AddStaffView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import SwiftUI

struct AddStaffView: View {
    @State private var staffName = ""
    @State private var staffEmail = ""
    @State private var staffMobile = ""
    @State private var staffAadhar = ""
    @State private var selectedRole: Staff.Role = .librarian
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var showAlert = false
    @State private var successMessage = ""
    @StateObject var staffViewModel = StaffViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                
                Button(action: {
                    isShowingImagePicker.toggle()
                }) {
                    if let image = selectedImage {
                        Image(uiImage: image)
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
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: $selectedImage, defaultImage: nil)
                }
                
                TextField("Name", text: $staffName)
                    .modifier(CustomTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $staffEmail)
                    .modifier(CustomTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                TextField("Mobile Number", text: $staffMobile)
                    .modifier(CustomTextFieldStyle())
                    .padding()
                
                TextField("Aadhar Number", text: $staffAadhar)
                    .modifier(CustomTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if selectedImage == nil {
                        showAlert = true
                    } else {
                        addStaff()
                    }
                }) {
                    Text("Add Staff")
                        .padding()
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .background(
                            staffName.isEmpty || staffEmail.isEmpty || staffMobile.isEmpty || staffAadhar.isEmpty ?
                            themeManager.selectedTheme.secondaryThemeColor :
                            themeManager.selectedTheme.primaryThemeColor
                        )
                        .cornerRadius(8)
                }
                .padding()
                .disabled(
                    staffName.isEmpty ||
                    staffEmail.isEmpty ||
                    staffMobile.isEmpty ||
                    staffAadhar.isEmpty
                )
                
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Profile Photo Required"), message: Text("Please select a profile photo."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addStaff() {
        guard !staffName.isEmpty,
              !staffEmail.isEmpty,
              !staffMobile.isEmpty,
              !staffAadhar.isEmpty,
              let selectedImage = selectedImage else {
            return
        }
        
        staffViewModel.addStaff(
            name: staffName,
            email: staffEmail,
            mobile: staffMobile,
            aadhar: staffAadhar,
            role: selectedRole,
            profilePhoto: selectedImage,
            completion: { success, error in
                if success {
                    showAlert = true
                    successMessage = "Staff added successfully!"
                } else {
                    if let error = error {
                        print("Error adding staff: \(error.localizedDescription)")
                    } else {
                        print("Unknown error adding staff.")
                    }
                }
            }
        )
    }
}


struct CustomTextFieldStyle: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    @FocusState private var isEditing: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isEditing || !content.getText().isEmpty ? themeManager.selectedTheme.primaryThemeColor : themeManager.selectedTheme.secondaryThemeColor,
                        lineWidth: 1
                    )
            )
            .padding(.horizontal)
            .onChange(of: content.getText(), perform: { _ in
                self.isEditing = true
            })
            .focused($isEditing)
    }
}

extension View {
    func getText() -> String {
        guard let view = self as? UITextField else { return "" }
        return view.text ?? ""
    }
}

struct AddStaffView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        AddStaffView()
            .environmentObject(themeManager)
    }
}
