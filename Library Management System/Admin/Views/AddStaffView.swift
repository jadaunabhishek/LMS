//
//  AddStaffView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 23/04/24.
//

import SwiftUI

struct AddStaffView: View {
    @State var staffName = ""
    @State var staffEmail = ""
    @State var staffMobile = ""
    @State var staffAadhar = ""
    @State var selectedRole: String = "librarian"
    
    @State var selectedImage: UIImage = UIImage()
    @State var isShowingImagePicker = false
    @State var isImageSelected = false
    
    @State var showSuccessAlert = false
    @State var showImageAlert = false
    
    @StateObject var staffViewModel = StaffViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            Button(action: {
                isShowingImagePicker.toggle()
            }) {
                if (isImageSelected) {
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
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, isImageSelected: $isImageSelected, sourceType: .photoLibrary)
            }
            
            CustomTextField(text: $staffName, placeholder: "Name")
            
            CustomTextField(text: $staffEmail, placeholder: "Email")
                .autocapitalization(.none)
            
            CustomTextField(text: $staffMobile, placeholder: "Mobile Number")
                .keyboardType(.numberPad)
            
            CustomTextField(text: $staffAadhar, placeholder: "Aadhar Number")
                .keyboardType(.numberPad)
                .alert(isPresented: $showImageAlert, content: imageAlert)
            
            PrimaryCustomButton(action: {
                if isImageSelected == true {
                    addStaff()
                } else {
                    print("No Image Selected")
                    showImageAlert = true
                }
            }, label: "Add Staff")
            .disabled(
                staffName.isEmpty ||
                staffEmail.isEmpty ||
                staffMobile.isEmpty ||
                staffAadhar.isEmpty ||
                isImageSelected == false
            )
            .alert(isPresented: $showSuccessAlert, content: successAlert)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func addStaff() {
        staffViewModel.addStaff(
            name: staffName,
            email: staffEmail,
            mobile: staffMobile,
            aadhar: staffAadhar,
            role: selectedRole,
            profilePhoto: selectedImage,
            completion: { success, error in
                if success {
                    DispatchQueue.main.async {
                        print("Data added to Firebase successfully!")
                        showSuccessAlert = true
                    }
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
    
    private func successAlert() -> Alert {
        Alert(title: Text("Success"),
              message: Text("Staff Added Successfully!"),
              dismissButton: .default(Text("OK")) {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func imageAlert() -> Alert {
        Alert(title: Text("Profile Photo Required"),
              message: Text("Please select a profile photo."),
              dismissButton: .default(Text("OK")))
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
