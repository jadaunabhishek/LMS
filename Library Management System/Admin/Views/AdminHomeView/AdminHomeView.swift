//
//  AdminHomeView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Charts
import TipKit

struct AdminHomeView: View {
    
    @Binding var adminTabSelection: Int
    
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
    
    @State var memberData: [Int] = [5, 10, 200, 300,0,0,0]
    
    @State private var isMemberSheetPresented: Bool = false
    @State private var isTotalRevenueSheetPresented: Bool = false
    var data: [(type: String, amount: Int)]{
        [(type: "Fine", amount : userAuthViewModel.totalIncome),
         (type: "Membership", amount : userAuthViewModel.allUsers.count * 50)
        ]
        
    }
    
    // Tip Data
    var tipProcedure = customizeTip()
    @State var totalRevenue : Int = 0
    
    
    var body: some View {
        NavigationView{
            VStack {
                if !isPageLoading {
                    ScrollView {
                        TipView(tipProcedure)
                            .padding([.leading, .trailing, .bottom])
                        
                        VStack(spacing:12){
                            VStack(alignment: .leading){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("requestCard"))
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(height: 170)
                                    
                                    // MARK: Total Revenue
                                    HStack() {
                                        VStack(alignment:.leading,spacing:8){
                                            VStack(alignment:.leading,spacing: 6){
                                                Text("Total Revenue")
                                                    .foregroundStyle(Color.gray)
                                                    .font(.title3)
                                                    
                                                Text("₹ \(totalRevenue)")
                                                    .font(.title)
                                                    .bold()
                                                    .padding(.leading,2)
                                            }
                                            HStack(spacing: 14){
                                                VStack(alignment:.leading){
                                                    HStack {
                                                        Circle()
                                                            .fill(Color(themeManager.selectedTheme.primaryThemeColor))
                                                            .frame(width: 10, height: 10)
                                                        Text(data[0].type)
                                                            .font(.caption)
                                                    }
                                                    Text("\(data[0].amount)")
                                                        .font(.caption2)
                                                        .padding(.leading)
                                                }
                                                
                                                VStack(alignment:.leading){
                                                    HStack {
                                                        Circle()
                                                            .fill(Color(themeManager.selectedTheme.primaryThemeColor).opacity(0.5))
                                                            .frame(width: 10, height: 10)
                                                        Text(data[1].type)
                                                            .font(.caption)
                                                    }
                                                    Text("\(data[1].amount)")
                                                        .font(.caption2)
                                                        .padding(.leading)
                                                }
                                            }
                                            .padding(6)
                                        }
                                        .padding()
                                        VStack{
                                            Chart(data, id: \.type) { dataItem in
                                                SectorMark(angle: .value("type", dataItem.amount),
                                                           angularInset: 1.5)
                                                .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
                                                .cornerRadius(14)
                                                .opacity(dataItem.type != "Fine" ? 0.7 : 1)
//                                                .annotation(position: .overlay) {
//                                                            let percentage = (Float(dataItem.amount) / Float(totalRevenue)) * 100
//                                                            let roundedPercentage = round(percentage)
//                                                            Text("\(Int(roundedPercentage))%")
//                                                        .foregroundStyle(Color.white)
//                                                        .font(.body)
//                                                            
//                                                }
                                                
                                            }
                                            
                                            .frame(width: 130)
                                        }
                                        Spacer()
                                    }
                                }
                                .onTapGesture {
                                    isTotalRevenueSheetPresented.toggle()
                                }
                                .sheet(isPresented: $isTotalRevenueSheetPresented) {
                                    RevenueDetailView( configViewModel: configViewModel)
                                }
                            }
                            .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                            .padding(.horizontal)
                            
                            // MARK: Member and Books
                            HStack(spacing:12){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("requestCard"))
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
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
                                .onTapGesture {
                                    isMemberSheetPresented.toggle()
                                }
                                .sheet(isPresented: $isMemberSheetPresented) {
                                    MemberDetailView(userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
                                        .presentationDetents([.fraction(0.70)])
                                }
                                
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("requestCard"))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
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
                                                .foregroundStyle(Color(themeManager.selectedTheme.bodyTextColor))
                                                .font(.title)
                                                .bold()
                                                .padding(.top)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .onTapGesture {
                                        adminTabSelection = 1
                                    }
                                
                            }
                            .padding(.horizontal)
                            
                            // MARK: Staff and Fine
                            HStack(spacing:12){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("requestCard"))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
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
                                                .foregroundStyle(Color(themeManager.selectedTheme.bodyTextColor))
                                                .font(.title)
                                                .bold()
                                                .padding(.top)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .onTapGesture {
                                        adminTabSelection = 2
                                    }
                                
                                
                                
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("requestCard"))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
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
                                                .foregroundStyle(Color(themeManager.selectedTheme.bodyTextColor))
                                                .font(.title)
                                                .bold()
                                                .padding(.top)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .onTapGesture {
                                        adminTabSelection = 3
                                    }
                                
                            }
                            .padding(.horizontal)
                            
                            // MARK: Theme and Brand Logo
                            HStack(spacing:12){
                                
                                Button{
                                    isThemeSelecterSheetPresented = true
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("requestCard"))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
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
                                    ColorSelecterView()
                                        .presentationDetents([.fraction(0.45)])
                                }
                                
                                Button {
                                    isLogoSelecterSheetPresented = true
                                } label : {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("requestCard"))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
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
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    
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
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    totalRevenue = userAuthViewModel.totalIncome + (userAuthViewModel.allUsers.count*50)
                    isPageLoading = false
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitle("Trove")
            .navigationBarItems(trailing: NavigationLink(destination: AdminProfileView(LibViewModel: librarianViewModel, configViewModel: configViewModel, staffViewModel: staffViewModel), label: {
                Image(systemName: "person.crop.circle")
                    .font(.title3)
                    .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
            }))
        }
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
        return AdminHomeView(adminTabSelection: .constant(1), librarianViewModel: LibViewModel, staffViewModel: staffViewMod, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
            .environmentObject(themeManager)
    }
}
