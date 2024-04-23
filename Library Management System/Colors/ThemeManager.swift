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
    let themes: [ThemeProtocol] = [Red(), Blue(), Green()]
    
    init() {
            self.selectedTheme = Red()
        }
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
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

