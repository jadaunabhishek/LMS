//
//  Textfields.swift
//  Library Management System
//
//  Created by admin on 02/05/24.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var text: String
    var placeholder: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TextField(placeholder.isEmpty ? " " : placeholder, text: $text)
            .font(.title3)
            .padding(12)
            .autocapitalization(.none)
            .foregroundColor(themeManager.selectedTheme.bodyTextColor)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .padding(5)
    }
}

struct SecTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var text: String
    var placeholder: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .font(.title3)
            .padding(12)
            .autocapitalization(.none)
            .foregroundColor(themeManager.selectedTheme.bodyTextColor)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .padding(5)
    }
}
