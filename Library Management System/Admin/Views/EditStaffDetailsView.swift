//
//  EditStaffDetailsView.swift
//  Library Management System
//
//  Created by admin on 28/04/24.
//

import SwiftUI

struct EditStaffDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var staffViewModel = StaffViewModel()
    @State var selectedImage: UIImage = UIImage()
    @State var isShowingImagePicker = false
    @State var isImageSelected = false
    @State private var name: String
    @State private var email: String
    @State private var mobile: String
    @State private var aadhar: String
    @State private var role: String = "Librarian"
    @State private var status: String = "Active"



    let staffMember: Staff

    init(staffMember: Staff) {
        _name = State(initialValue: staffMember.name)
        _email = State(initialValue: staffMember.email)
        _mobile = State(initialValue: staffMember.mobile)
        _aadhar = State(initialValue: staffMember.aadhar)
        _role = State(initialValue: staffMember.role)
        
        self.staffMember = staffMember
    }

    var body: some View {
        if let profileURL = URL(string: staffMember.profileImageURL) {
            VStack {
                Button(action: {
                    isShowingImagePicker.toggle()
                }) {
                    ZStack {
                        if isImageSelected {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .onTapGesture {
                                    isShowingImagePicker.toggle() // Toggle image picker on tap to edit
                                }
                        } else {
                            AsyncImage(url: profileURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.top, 20)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, isImageSelected: $isImageSelected, sourceType: .photoLibrary)
                }
            }
        }
        Form {
            Section(header: Text("Staff Details").font(.headline).foregroundColor(themeManager.selectedTheme.bodyTextColor)) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Mobile", text: $mobile)
                    .keyboardType(.phonePad)
                TextField("Aadhar", text: $aadhar)
                    .keyboardType(.numberPad)
                Picker("Role", selection: $role) {
                           Text("Librarian").tag("Librarian")
                           Text("Member").tag("Member")
                       }
                       .pickerStyle(SegmentedPickerStyle())
                Picker("Status", selection: $status) {
                    Text("Active").tag("Active")
                    Text("Inactive").tag("Inactive")
                }
                .pickerStyle(SegmentedPickerStyle())

            }

            Button(action: updateStaffDetails) {
                Text("Update Details")
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
            }
        }
        .padding()
        .navigationTitle("Edit Staff Details")
    }

    private func updateStaffDetails() {
        staffViewModel.updateStaff(
                staffID: staffMember.userID,
                name: name,
                email: email,
                mobile: mobile,
                aadhar: aadhar,
                role: staffMember.role,
                profilePhoto: selectedImage,
                status: staffMember.status,
                isImageUpdated: true
        ) { success, error in
            if success {
                
                print("Staff details updated successfully")
            } else {
                
                print("Failed to update staff details: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}



//struct EditStaffDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let themeManager = ThemeManager()
//        return EditStaffDetailsView(userID: "35PmRqJThks5zqXgn02g")
//            .environmentObject(themeManager)
//            .environmentObject(staffViewModel)
//    }
//}
