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
        let screenWidth = UIScreen.main.bounds.width
        let newwidth = screenWidth * 0.40
        let newheight = screenWidth * 0.35
        NavigationStack {
            
            ZStack(alignment:.leading){
                Rectangle()
                    .fill(themeManager.randomColor())
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
            .frame(width: newwidth, height: newheight)
        }
    }
    
}


struct AdminCategoriesCard_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return AdminCategoriesCard(category: "Cool-Days")
            .environmentObject(themeManager)
    }
}
