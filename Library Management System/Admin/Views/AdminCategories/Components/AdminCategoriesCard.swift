//
//  AdminCategoriesCard.swift
//  Library Management System
//
//  Created by user2 on 23/04/24.
//

import SwiftUI

struct AdminCategoriesCard: View {
    @State var category: String
    @State var isEditSheetPresented: Bool = false
    var body: some View {
        NavigationStack{
            
            ZStack(alignment:.leading){
                Rectangle()
                    .fill(randomColor())
                    .cornerRadius(12)
                VStack(alignment:.leading){
                    Spacer()
                    Text(category)
                        .font(.title3)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .foregroundStyle(Color.white)
                        .padding()
                }
            }.frame(width: 170, height: 120)
            .sheet(isPresented: $isEditSheetPresented ) {
                
                NavigationView {
                    EditCategoriesView(isSheetPresented: $isEditSheetPresented)
                        .background(.gray)
                        .navigationBarItems(
                            trailing:  Button(action:{isEditSheetPresented.toggle()}){
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        )
                    //                        .environment(\.colorScheme, .dark)
                }
                .presentationDetents([.medium, .large])
            }
            
            
        }
    }
    func gradient() -> LinearGradient {
        let numberOfColors = Int.random(in: 2...5) // Generate random number of colors between 2 and 5
        var colors: [Color] = []
        for _ in 0..<numberOfColors {
            colors.append(randomColor()) // Add random colors to the array
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
    }

    
    func randomColor() -> Color {
        let red = Double.random(in: 0.0...0.6) // Adjusted range for darker red
        let green = Double.random(in: 0.0...0.6) // Adjusted range for darker green
        let blue = Double.random(in: 0.0...0.6) // Adjusted range for darker blue
        return Color(red: red, green: green, blue: blue)
    }

//    func randomColor() -> Color {
//        let red = Double.random(in: 0.5...1)
//        let green = Double.random(in: 0.5...1)
//        let blue = Double.random(in: 0.5...1)
//        return Color(red: red, green: green, blue: blue)
//    }
}
#Preview {
    AdminCategoriesCard(category: "Cool-Dayejejdjwjejwuejwdujwuwj")
}
