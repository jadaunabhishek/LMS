//
//  Picker.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 03/05/24.
//

import SwiftUI

struct PickerButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isSelected ? .white : Color(.systemGray6))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? themeManager.selectedTheme.primaryThemeColor : Color(.systemGray4))
                .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
