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


struct BarChartWithLine: View {
    @State var memberData: [Int] = [5, 10, 200, 300, 0, 0, 0]
    
    var body: some View {
        VStack {
            VStack{
                
            }
            
            HStack(spacing: 10) {
                ForEach(0..<memberData.count, id: \.self) { index in
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 20, height: CGFloat(memberData[index]))
                    }
                }
            }
            .padding(.top, 20)
            
        }
    }
}


#Preview {
    ColorSelecterView()
}
