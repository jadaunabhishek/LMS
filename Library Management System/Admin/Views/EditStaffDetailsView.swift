//
//  EditStaffDetailsView.swift
//  Library Management System
//
//  Created by admin on 28/04/24.
//

import SwiftUI

struct EditStaffDetailsView: View {
    let staffMember: Staff
    
    @State var name: String
    @State var email: String
    @State var mobile: String
    @State var aadhar: String
    
    @State var isShowingImagePicker = false
    @State var isImageSelected = false
    @State var selectedImage: UIImage = UIImage()
    
    @State private var showConfirmationAlert = false
    @State private var navigateToAdminStaffView = false
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var themeManager: ThemeManager
    @State var staffViewModel = StaffViewModel()
    
    init(staffMember: Staff) {
        _name = State(initialValue: staffMember.name)
        _email = State(initialValue: staffMember.email)
        _mobile = State(initialValue: staffMember.mobile)
        _aadhar = State(initialValue: staffMember.aadhar)
        self.staffMember = staffMember
    }
    
    var body: some View {
        ScrollView{
            VStack{
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
                                            isShowingImagePicker.toggle()
                                        }
                                } else {
                                    AsyncImage(url: profileURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 140, height: 140)
                                            .clipShape(Circle())
                                            .padding(.top, 20)
                                    } placeholder: {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 140, height: 140)
                                            .clipShape(Circle())
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
                VStack(alignment: .leading) {
                    
                    Text("Name:")
                        .font(.callout)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    CustomTextField(text: $name, placeholder: "")
                    Text("Email:")
                        .font(.callout)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    CustomTextField(text: $email, placeholder: "")
                        .keyboardType(.emailAddress)
                    Text("Mobile:")
                        .font(.callout)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    CustomTextField(text: $mobile, placeholder: "")
                        .keyboardType(.phonePad)
                    
                    Text("Aadhar:")
                        .font(.callout)
                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                    CustomTextField(text: $aadhar, placeholder: "")
                        .keyboardType(.numberPad)
                }
                .padding()
                
                SecondaryCustomButton(action: {
                    showConfirmationAlert = true
                }, label: "Delete Staff")
                .alert(isPresented: $showConfirmationAlert, content: {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete this staff member?"),
                        primaryButton: .destructive(Text("Delete"), action: {
                            deleteStaff()
                        }),
                        secondaryButton: .cancel()
                    )
                }).padding(.bottom, 90)
                
                NavigationLink(value: navigateToAdminStaffView) {
                    Text("")
                }
                .navigationDestination(isPresented: $navigateToAdminStaffView) {
                    AdminStaffView()
                }
                .navigationTitle("Edit Staff")
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor),
                trailing: Button("Save") {
                    Task{
                        updateStaffDetails()
                        staffViewModel.getStaff()
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
            )
        }
    }
    
    
    private func deleteStaff() {
        staffViewModel.deleteStaff(staffID: staffMember.userID)
        navigateToAdminStaffView = true
    }
    
    private func updateStaffDetails() {
        staffViewModel.updateStaff(
            staffID: staffMember.userID,
            name: name,
            email: email,
            mobile: mobile,
            aadhar: aadhar,
            profilePhoto: selectedImage,
            isImageUpdated: isImageSelected
        ) { success, error in
            if success {
                
                print("Staff details updated successfully")
            } else {
                
                print("Failed to update staff details: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

struct EditStaffDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var staffViewModel = StaffViewModel()
        let themeManager = ThemeManager()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'ZZZ"
        let createdOnDate = dateFormatter.date(from: "April 24, 2024 at 12:40:44 PM UTC+5:30") ?? Date()
        let updatedOnDate = dateFormatter.date(from: "April 24, 2024 at 12:40:44 PM UTC+5:30") ?? Date()
        let sampleStaff = Staff(
            userID: "VzCFTZhEjoMZpFuzBw1Kt1S1AGm1",
            name: "https://firebasestorage.googleapis.com:443/v0/b/library-management-syste-6cc1e.appspot.com/o/staffProfileImages%2F35PmRqJThks5zqXgn02g.jpeg?alt=media&token=6334f513-e00e-4d77-83fe-e9be3dae9c5a",
            email: "Manvi Singhal",
            mobile: "librarian",
            profileImageURL: "manvi.singhal03@gmail.com",
            aadhar: "6976927239",
            role: "789269282392",
            password: "gyhg",
            createdOn: createdOnDate,
            updatedOn: updatedOnDate
        )
        
        return EditStaffDetailsView(staffMember: sampleStaff)
            .environmentObject(themeManager)
            .environmentObject(staffViewModel)
    }
}
