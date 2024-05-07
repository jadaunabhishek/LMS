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
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var librarianViewModel: LibrarianViewModel
    @ObservedObject var staffViewModel: StaffViewModel
    @ObservedObject var userAuthViewModel: AuthViewModel
    @State var isThemeSelecterSheetPresented: Bool = false
    @State var isPageLoading: Bool = true
    var body: some View {
        
        VStack(spacing:0){
            if !isPageLoading {
                ZStack(alignment:.bottomLeading){
                    Rectangle()
                        .colorInvert()
                        .frame(height:110)
                    HStack{
                        Text("Hello! \(staffViewModel.currentStaff[0].name) ")
                            .font(.title3)
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    Divider()
                }
                ScrollView {
                    VStack(spacing:8){
                        VStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray4).opacity(0.5))
                                    .frame(height: 150)
                                    .padding(.horizontal)
                                
                                VStack(alignment: .leading){
                                    Text("Total Revenue")
                                        .foregroundStyle(Color.gray)
                                        .font(.system(size: 20))
                                    HStack{
                                        Text("₹")
                                            .font(.system(size: 30))
                                        Text(String(userAuthViewModel.totalIncome))
                                            .padding(.top,8)
                                            .font(.system(size: 40))
                                            .bold()
                                    }
                                }
                            }
                        }
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray4).opacity(0.5))
                                    .padding([.leading])
                                    .frame(height: 100)
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "person.fill")
                                            .foregroundStyle(Color.gray)
                                        Text("Members")
                                            .foregroundStyle(Color.gray)
                                    }
                                    Text(String("\(userAuthViewModel.allUsers.count)"))
                                        .font(.title.bold())
                                        .padding(2)
                                }
                                .offset(x: -16)
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray4).opacity(0.5))
                                    .padding([.trailing])
                                    .frame(height: 100)
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "text.book.closed.fill")
                                            .foregroundStyle(Color.gray)
                                        Text("Books")
                                            .foregroundStyle(Color.gray)
                                    }
                                    Text(String(librarianViewModel.allBooks.count))
                                        .font(.title.bold())
                                        .padding(2)
                                }
                                .offset(x: -40)
                            }
                        }
                        HStack{
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .padding([.leading])
                                        .frame(height: 100)
                                    VStack(alignment:.leading){
                                        HStack{
                                            Image(systemName: "person.3.fill")
                                                .foregroundStyle(Color.gray)
                                            Text("Staffs")
                                                .foregroundStyle(Color.gray)
                                        }
                                        Text(String(staffViewModel.currentStaff.count))
                                            .font(.title.bold())
                                            .padding(2)
                                    }
                                    .offset(x: -20)
                                }
                                ZStack(alignment:.topLeading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .padding([.leading,.bottom])
                                        .frame(height: 124)
                                    VStack(alignment:.leading){
                                        
                                        Text("Fine Remaining")
                                            .foregroundStyle(Color.gray)
                                        
                                        Text("Rs. \(userAuthViewModel.finesPending)")
                                            .font(.title.bold())
                                            .padding(2)
                                    }
                                    .offset(x:36,y:20)
                                    
                                }
                            }
                            Button{
                                isThemeSelecterSheetPresented = true
                            }label: {
                                ZStack(alignment:.topLeading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray4).opacity(0.5))
                                        .padding([.trailing,.bottom])
                                        .frame(height: 234)
                                    VStack(alignment:.leading){
                                        Text("Theme Color")
                                            .foregroundStyle(Color.gray)
                                            .padding(.bottom)
                                        VStack{
                                            Image("AppLogo")
                                                .resizable()
                                                .frame(width: 140,height: 90)
                                        }
                                        .frame(height: 60)
                                        .padding(.vertical)
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
                                        .padding(.leading,6)
                                    }
                                    .padding()
                                }
                                .sheet(isPresented: $isThemeSelecterSheetPresented) {
                                    colorSelecterView(isSheetPresented: $isThemeSelecterSheetPresented)
                                        .presentationDetents([.fraction(0.45)])
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                                        VStack(alignment:.leading){
                                            Text("Trending")
                                                .font(.title2)
                                            ScrollView(.horizontal){
                                                HStack{
                                                    ForEach(1...8, id: \.self) { index in
                                                        bookCard()
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            //            .background(Color(.systemGray3).opacity(0.4))
            else{
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea(.all)
        
        
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
}

struct bookCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemGray4).opacity(0.5))
            .frame(width:100, height: 200)
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
        return AdminHomeView(librarianViewModel: LibViewModel, staffViewModel: staffViewMod, userAuthViewModel: userAuthViewModel)
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


#Preview{
    colorSelecterView(isSheetPresented: .constant(true))
        .environmentObject(ThemeManager())
}
