//
//  FirstScreenView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI

struct MemberFirstScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
            Text("Hi world")
                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
        }
    }
}

struct MemberFirstScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MemberFirstScreenView()
            .environmentObject(themeManager)
    }
}
