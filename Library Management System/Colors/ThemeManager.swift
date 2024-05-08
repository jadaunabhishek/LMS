//
//  ThemeManager.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var selectedTheme: ThemeProtocol = Red()
    @ObservedObject var configModel = ConfigViewModel()
    
    let themes: [ThemeProtocol] = [Red(), Blue(), Green()]
    
    init() {
        self.selectedTheme = Red()
    }
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
    
    func setBaseTheme() async{
        
        configModel.fetchConfig()
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
        if(configModel.currentConfig[0].accentColor == "Red"){
            selectedTheme = Red()
        }
        else if(configModel.currentConfig[0].accentColor == "Blue"){
            selectedTheme = Blue()
        }
        else if(configModel.currentConfig[0].accentColor == "Green"){
            selectedTheme = Green()
        }
    }
    
    func updateTheme(_ theme: ThemeProtocol) {
        let accentColor: String
        switch theme {
        case is Red:
            accentColor = "Red"
        case is Blue:
            accentColor = "Blue"
        case is Green:
            accentColor = "Green"
        default:
            accentColor = ""
        }
        configModel.updateLibraryTheme(configId: "HJ9L6mDbi01TJvX3ja7Z", acentColor: accentColor)
    }
}

struct Red: ThemeProtocol {
    var primaryThemeColor: Color { return Color("rdPrimaryThemeColor") }
    var secondaryThemeColor: Color { return Color("rdSecondaryThemeColor") }
    var bodyTextColor: Color { return Color("rdBodyTextColor") }
}

struct Blue: ThemeProtocol {
    var primaryThemeColor: Color { return Color("blPrimaryThemeColor") }
    var secondaryThemeColor: Color { return Color("blSecondaryThemeColor") }
    var bodyTextColor: Color { return Color("blBodyTextColor") }
}

struct Green: ThemeProtocol {
    var primaryThemeColor: Color { return Color("grPrimaryThemeColor") }
    var secondaryThemeColor: Color { return Color("grSecondaryThemeColor") }
    var bodyTextColor: Color { return Color("grBodyTextColor") }
}
