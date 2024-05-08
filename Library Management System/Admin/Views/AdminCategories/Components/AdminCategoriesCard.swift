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
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment:.leading){
                Rectangle()
                    .fill(randomColor())
                    .cornerRadius(12)
                 
                VStack(alignment:.leading){
                    Spacer()
                    Text(category)
                        .font(.title3)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                        .padding()
                }
            }
            .frame(width: 170, height: 120)
        }
    }
    
    func randomColor() -> Color {
        let systemColors: [Color] = [.red, .green, .blue, .orange, .yellow, .pink, .purple, .teal, .cyan, .indigo, .brown, .gray, .mint]
        return systemColors.randomElement() ?? .red
    }
}


struct AdminCategoriesCard_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminCategoriesCard(category: "Cool-Days")
            .environmentObject(themeManager)
    }
}
