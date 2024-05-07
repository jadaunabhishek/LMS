//
//  AdminHomeView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
struct AdminHomeView: View {
    
    @ObservedObject var librarianViewModel: LibrarianViewModel
    @ObservedObject var staffViewModel: StaffViewModel
    @ObservedObject var userAuthViewModel: AuthViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    
    @State var isPageLoading: Bool = true
    @State var isThemeSelecterSheetPresented: Bool = false
    
    @State var isLogoSelecterSheetPresented: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var isLogoSelected = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView{
            VStack {
                if !isPageLoading {
                    ScrollView {
                        VStack(spacing:12){
                            VStack(alignment: .leading){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .frame(height: 150)
                                    
                                    VStack{
                                        Text("Total Revenue")
                                            .foregroundStyle(Color.gray)
                                            .font(.title3)
                                        Text("₹ \(userAuthViewModel.totalIncome)")
                                            .font(.title)
                                            .bold()
                                            .padding(.top)
                                    }
                                }
                            }
                            
                            HStack(spacing:12){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .frame(height: 125)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Members")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text(String("\(userAuthViewModel.allUsers.count)"))
                                            .font(.title)
                                            .bold()
                                            .padding(.top)
                                    }
                                    .padding(.horizontal)
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .frame(height: 125)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Books")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text(String("\(librarianViewModel.allBooks.count)"))
                                            .font(.title)
                                            .bold()
                                            .padding(.top)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            HStack(spacing:12){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .frame(height: 125)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Staff")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text(String("\(staffViewModel.currentStaff.count)"))
                                            .font(.title)
                                            .bold()
                                            .padding(.top)
                                    }
                                    .padding(.horizontal)
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .frame(height: 125)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Fine")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text("₹ \(userAuthViewModel.finesPending)")
                                            .font(.title)
                                            .bold()
                                            .padding(.top)
                                    }
                                    .padding(.horizontal)
                                }
                                
                            }
                            
                            HStack(spacing:12){
                                
                                Button{
                                    isThemeSelecterSheetPresented = true
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.systemGray4).opacity(0.5))
                                            .frame(height: 170)
                                        VStack(alignment: .leading){
                                            HStack(alignment: .top){
                                                Text("Theme")
                                                    .font(.title3)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.subheadline)
                                            }
                                            .foregroundStyle(Color.gray)
                                            .padding(.top)
                                            Spacer()
                                            HStack(spacing:0){
                                                Rectangle()
                                                    .fill(themeManager.selectedTheme.primaryThemeColor)
                                                
                                                Rectangle()
                                                    .fill(themeManager.selectedTheme.secondaryThemeColor)
                                                
                                                Rectangle()
                                                    .fill(themeManager.selectedTheme.secondaryThemeColor.opacity(0.5))
                                                    .background(Color.white)
                                            }
                                            .frame(width: 130, height: 40)
                                            .cornerRadius(5)
                                            .padding(.bottom, 30)
                                        }
                                        .padding(.horizontal)
                                    }}
                                .sheet(isPresented: $isThemeSelecterSheetPresented) {
                                    colorSelecterView(isSheetPresented: $isThemeSelecterSheetPresented)
                                        .presentationDetents([.fraction(0.45)])
                                }
                                
                                Button {
                                    isLogoSelecterSheetPresented = true
                                } label : {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.systemGray4).opacity(0.5))
                                            .frame(height: 170)
                                        VStack {
                                            VStack(alignment: .leading) {
                                                HStack(alignment: .top) {
                                                    Text("Brand Logo")
                                                        .font(.title3)
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .font(.subheadline)
                                                }
                                                .foregroundStyle(Color.gray)
                                                .padding()
                                            }
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .center) {
                                                if isLogoSelected {
                                                    Image(uiImage: selectedImage)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 80, height: 80)
                                                        .clipShape(Circle())
                                                        .padding(.bottom, 20)
                                                } else if let logoURL = configViewModel.currentConfig.first?.logo {
                                                    AsyncImage(url: URL(string: logoURL)) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 80, height: 80)
                                                                .clipShape(Circle())
                                                                .padding(.bottom, 30)
                                                        default:
                                                            ZStack {
                                                                Circle()
                                                                    .frame(width: 80, height: 80)
                                                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                                                Image(systemName: "books.vertical.fill")
                                                                    .font(.system(size: 45))
                                                                    .foregroundColor(.white)
                                                            }
                                                            .padding(.bottom, 20)
                                                        }
                                                    }
                                                } else {
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                                        Image(systemName: "books.vertical.fill")
                                                            .font(.system(size: 45))
                                                            .foregroundColor(.white)
                                                    }
                                                    .padding(.bottom, 20)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }}
                                .sheet(isPresented: $isLogoSelecterSheetPresented) {
                                    ImagePicker(selectedImage: $selectedImage, isImageSelected: $isLogoSelected, sourceType: .photoLibrary)
                                }
                                .onChange(of: selectedImage) { newImage in
                                    if isLogoSelected {
                                        configViewModel.updateLibraryLogo(libraryLogo: newImage, configId: configViewModel.currentConfig[0].configID)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
                else{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
            .task {
                do{
                    isPageLoading = true
                    userAuthViewModel.fetchAllUsers()
                    librarianViewModel.getBooks()
                    staffViewModel.getStaff()
                    staffViewModel.getAllStaff()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    isPageLoading = false
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Hello!)")
    }
}

struct ThemeView: View {
    let theme: ThemeProtocol
    
    var body: some View {
        Circle()
            .fill(theme.primaryThemeColor)
            .frame(width: 40, height: 40)
            .padding(.trailing)
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var staffViewMod = StaffViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var userAuthViewModel = AuthViewModel()
        @StateObject var configViewModel = ConfigViewModel()
        return AdminHomeView(librarianViewModel: LibViewModel, staffViewModel: staffViewMod, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
            .environmentObject(themeManager)
    }
}

struct colorSelecterView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var configManager = ConfigViewModel()
    @Binding var isSheetPresented: Bool
    @State var selectedTheme: ThemeProtocol?
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    guard let selectedTheme = selectedTheme else { return }
                    themeManager.setTheme(selectedTheme)
                    themeManager.updateTheme(selectedTheme)
                    isSheetPresented = false
                }) {
                    Text("Save")
                        .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                }
                .padding([.top,.trailing])
            }
            .padding([.top,.trailing])
            Text("Select Theme")
                .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                .font(.headline)
                .padding()
            
            HStack {
                ForEach(themeManager.themes, id: \.primaryThemeColor) { theme in
                    Button(action: {
                        selectedTheme = theme
                    }) {
                        ThemeView(theme: theme)
                    }
                }
            }
            
            Text("Selected Theme:")
                .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                .font(.headline)
                .padding()
            ThemeView(theme: selectedTheme ?? themeManager.selectedTheme)
            Spacer()
        }
    }
}
