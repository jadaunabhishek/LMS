//
//  AdminHomeView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI

struct AdminHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            Text("Select Theme")
                .font(.headline)
                .padding()

            HStack{
                ForEach(themeManager.themes, id: \.primaryThemeColor) { theme in
                    Button(action: {
                        themeManager.setTheme(theme)
                    }) {
                        ThemeView(theme: theme)
                    }
                }
            }
            
            Text("Selected Theme:")
                .font(.headline)
                .padding()
            ThemeView(theme: themeManager.selectedTheme)
        }
        .padding()
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
