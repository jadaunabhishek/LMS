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
    @State private var selectedRole: Staff.StaffRole = .librarian
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @StateObject var staffViewModel = StaffViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            TextField("Staff Name", text: $staffName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Staff Email", text: $staffEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Staff Mobile", text: $staffMobile)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Staff Aadhar", text: $staffAadhar)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Picker("Staff Role", selection: $selectedRole) {
                ForEach(Staff.StaffRole.allCases, id: \.self) { role in
                    Text(role.rawValue).tag(role)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
            }
            
            Button(action: {
                isShowingImagePicker.toggle()
            }) {
                Text("Select Profile Photo")
            }
            .padding()
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedImage, defaultUserImage: nil)
            }
            
            Button(action: {
                addStaff()
            }) {
                Text("Add Staff")
                    .padding()
                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    .background(themeManager.selectedTheme.primaryThemeColor)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Add Staff")
    }
    
    
    private func addStaff() {
        guard !staffName.isEmpty, !staffEmail.isEmpty, !staffMobile.isEmpty, !staffAadhar.isEmpty, let selectedImage = selectedImage else {
            // Handle empty fields or missing image
            return
        }
        
        staffViewModel.addStaff(
            staffName: staffName,
            staffEmail: staffEmail,
            staffMobile: staffMobile,
            staffAadhar: staffAadhar,
            staffRole: selectedRole,
            profilePhoto: selectedImage
        ) { success, error in
            if success {
                print("Staff added successfully!")
            } else {
                if let error = error {
                    print("Error adding staff: \(error.localizedDescription)")
                } else {
                    print("Unknown error adding staff.")
                }
            }
        }
    }
}

extension Staff.StaffRole {
    static var allCases: [Staff.StaffRole] {
        return [.librarian, .staff]
    }
}


struct AddStaffView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        AddStaffView()
            .environmentObject(themeManager)
    }
}
