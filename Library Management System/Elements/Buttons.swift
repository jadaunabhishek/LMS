//
//  Buttons.swift
//  Library Management System
//
//  Created by admin on 02/05/24.
//

import SwiftUI

struct PrimaryCustomButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title3)
                .fontWeight(.bold)
//                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.selectedTheme.primaryThemeColor)
                .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SecondaryCustomButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.selectedTheme.secondaryThemeColor)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


