//
//  ColorSelecterView.swift
//  Library Management System
//
//  Created by user2 on 08/05/24.
//

import SwiftUI

struct ColorSelecterView: View {
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var configManager = ConfigViewModel()
    @State var selectedTheme: ThemeProtocol?
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    guard let selectedTheme = selectedTheme else { return }
                    themeManager.setTheme(selectedTheme)
                    themeManager.updateTheme(selectedTheme)
                    dismiss()
                }) {
                    Text("Save")
                        .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                }
                .padding([.top,.trailing])
            }
            .padding([.top,.trailing])
            Text("Select Theme")
                .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                .font(.headline)
                .padding()
            
            HStack {
                ForEach(themeManager.themes, id: \.primaryThemeColor) { theme in
                    Button(action: {
                        selectedTheme = theme
                    }) {
                        ThemeView(theme: theme)
                    }
                }
            }
            
            Text("Selected Theme:")
                .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                .font(.headline)
                .padding()
            ThemeView(theme: selectedTheme ?? themeManager.selectedTheme)
            Spacer()
        }
    }
}

#Preview {
    ColorSelecterView()
}
