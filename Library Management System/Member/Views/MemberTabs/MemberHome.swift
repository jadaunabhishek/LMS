//
//  MemberHome.swift
//  Library Management System
//
//  Created by admin on 24/04/24.
//

import SwiftUI

struct MemberHome: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        NavigationView{
            ScrollView{
                //            HStack{
                //                Text("Hi! John").font(.title2)
                //                    .fontWeight(.semibold)
                //                Spacer()
                //                Image(systemName: "person.fill").resizable().frame(width: 25,height: 25)
                //            }.padding()
                VStack{
                    ZStack {
                        Rectangle()
                            .foregroundColor(themeManager.selectedTheme.secondaryThemeColor)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                            .frame(height: 230)
                            .navigationBarBackButtonHidden(true)
                            .navigationTitle("Home")
                        HStack{
                            VStack(alignment: .leading, spacing: 10) {
                                Text("DATE")
                                    .font(.title3)
                                    .fontWeight(.bold).padding(.bottom, 15)
                                Text("Author:")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("Title")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("ISBN 1234")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .fontWeight(.semibold).padding(.top, 30)
                            }.padding().foregroundColor(.white)
                            Spacer()
                            VStack{
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 18)
                                        .opacity(0.3)
                                        .foregroundColor(.gray)
                                        .frame(width: 150, height: 150)
                                    
                                    Circle()
                                        .trim(from: 0.0, to: 1)
                                        .stroke(style: StrokeStyle(lineWidth:20, lineCap: .round, lineJoin: .round))
                                        .frame(width: 150, height: 150) .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                        .rotationEffect(.degrees(-90))
                                    VStack{
                                        Text("10")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                        Text("Days left")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                    }
                                }.padding()
                            }.padding(.bottom, 35)
                                .padding(.trailing, 15)
                            
                        }
                        Spacer()
                    }.padding()
                    ScrollView(.horizontal){
                        HStack{
                            ZStack(alignment: .bottomLeading) {
                                Rectangle()
                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                    .frame(width: 230, height: 130)
                                HStack{
                                    Text("My Books").font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Image(systemName: "book")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }.padding()
                                
                            }
                            ZStack(alignment: .bottomLeading) {
                                Rectangle()
                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                    .frame(width: 210, height: 130)
                                HStack{
                                    Text("History").font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Image(systemName: "square.stack.3d.up.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }.padding()
                            }
                        }.padding()
                    }
                    Text("New Release")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 20) {
                            ForEach(0..<10) { _ in
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 100, height: 150)
                            }
                            
                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                        }
                    }
                }
            }
        }
    }
}

struct MemberHome_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MemberHome()
            .environmentObject(themeManager)
    }
}
