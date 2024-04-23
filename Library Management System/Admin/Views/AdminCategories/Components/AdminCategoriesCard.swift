//
//  AdminCategoriesCard.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminCategoriesCard: View {
    @State var category: String
    var body: some View {
        
        ZStack(alignment:.leading){
            Rectangle()
                .fill(gradient())
                .frame(width: 150, height: 100)
                .cornerRadius(12)
                .padding(6)
            Text(category)
                .font(.title3)
                .padding(.bottom, 8)
                .offset(x:16,y:30)
                .bold()
        }
    }
    func gradient() -> LinearGradient {
        let colors: [Color] = [randomColor(), randomColor()]
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
    }
    
    //    func randomColor() -> Color {
    //        let red = Double.random(in: 0.7...1)
    //        let green = Double.random(in: 0.7...1)
    //        let blue = Double.random(in: 0.7...1)
    //        return Color(red: red, green: green, blue: blue)
    //    }
    
    func randomColor() -> Color {
        let red = Double.random(in: 0.5...1)
        let green = Double.random(in: 0.5...1)
        let blue = Double.random(in: 0.5...1)
        return Color(red: red, green: green, blue: blue)
    }
}
#Preview {
    AdminCategoriesCard(category: "Cool-Day")
}
