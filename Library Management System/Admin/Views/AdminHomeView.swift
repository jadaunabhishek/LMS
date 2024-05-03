//
//  AdminHomeView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI

struct AdminHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var librarianViewModel = LibrarianViewModel()
    @ObservedObject var staffViewModel = StaffViewModel()
    var body: some View {
        VStack(spacing:0){
            ZStack(alignment:.bottomLeading){
                Rectangle()
                    .colorInvert()
                    .frame(height:110)
                HStack{
                    Text("Hello! Maanvi")
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
                VStack{
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray4).opacity(0.5))
//                                .colorInvert()
                                .frame(height: 150)
                                .padding(.horizontal)
                                
                            VStack(alignment: .leading){
                                Text("Total Revenue")
                                    .font(.system(size: 20))
                                    .offset(x: -80)
                                HStack{
                                    Text("$")
                                        .padding(.top,8)
                                        .font(.system(size: 30))
                                    Text("50000")
                                        .padding(.top,8)
                                        .font(.system(size: 40))
                                        .bold()
                                }
                                    
                                Text("per month")
                                    .font(.callout.bold())
                                    .offset(x:160,y:10)
                            }
                        }
                    }
                    .padding(.bottom,8)
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray4).opacity(0.5))
//                                .stroke(Color(.systemGray3))
                                .padding([.leading])
                                .frame(height: 100)
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Color.gray)
                                    Text("Members")
                                        .foregroundStyle(Color.gray)
                                }
                                Text("1234")
                                    .font(.title.bold())
                                    .padding(2)
                            }
                            .offset(x: -16)
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray4).opacity(0.5))
//                                .stroke(Color(.systemGray3))
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
                    .padding(.bottom,8)
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
                            
                            .padding(.bottom, 8)
                            ZStack(alignment:.topLeading){
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray4).opacity(0.5))
                                    .padding([.leading,.bottom])
                                    .frame(height: 124)
                                VStack(alignment:.leading){
                                    
                                        Text("Fine Remaining")
                                            .foregroundStyle(Color.gray)
                                    
                                    Text("$ 124")
                                        .font(.title.bold())
                                        .padding(2)
                                }
                                .offset(x:36,y:20)
                                
                            }
                        }
                        ZStack(alignment:.topLeading){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray4).opacity(0.5))
                                .padding([.trailing,.bottom])
                                .frame(height: 236)
                            VStack(alignment:.leading){
                                Text("Theme Color")
                                    .foregroundStyle(Color.gray)
                                    .padding(.bottom)
                                VStack{
                                    Text("Hi")
                                }
                                .frame(height: 60)
                                VStack(spacing:0){
                                    Rectangle()
                                        .fill(themeManager.selectedTheme.primaryThemeColor)
                                        .frame(width: 130)
                                    Rectangle()
                                        .fill(themeManager.selectedTheme.secondaryThemeColor)
                                        .frame(width: 130)
                                    Rectangle()
                                        .fill(themeManager.selectedTheme.bodyTextColor)
                                        .frame(width: 130)
                                }
                                .frame(height: 60)
                                .cornerRadius(5)
                                .padding(.leading,6)
                                
                            }
                            .padding()
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
//            .background(Color(.systemGray3).opacity(0.4))
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

struct bookCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color(.systemGray3))
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
        return AdminHomeView()
            .environmentObject(themeManager)
    }
}



//            Text("Select Theme")
//                .font(.headline)
//                .padding()

//            HStack{
//                ForEach(themeManager.themes, id: \.primaryThemeColor) { theme in
//                    Button(action: {
//                        themeManager.setTheme(theme)
//                    }) {
//                        ThemeView(theme: theme)
//                    }
//                }
//            }
//
//            Text("Selected Theme:")
//                .font(.headline)
//                .padding()
//            ThemeView(theme: themeManager.selectedTheme)
