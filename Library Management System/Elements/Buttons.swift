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
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.selectedTheme.primaryThemeColor)
                .cornerRadius(15)
                .foregroundColor(.white)
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
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.selectedTheme.secondaryThemeColor)
                .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SignupCustomButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let action: () -> Void
    let label: String
    let imageName: String 

    var body: some View {
        Button(action: action) {
            HStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)

                Text(label)
                    .font(.title3)
                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.white))
            .cornerRadius(15)
            .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 1) // Add a black border with width 1
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
