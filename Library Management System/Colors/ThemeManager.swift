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
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
}

struct Red: ThemeProtocol {
    var primaryThemeColor: Color { return Color("rdPrimaryThemeColor") }
    var secondoryThemeColor: Color { return Color("rdSecondoryThemeColor") }
    var bodyTextColor: Color { return Color("rdBodyTextColor") }
}

struct Blue: ThemeProtocol {
    var primaryThemeColor: Color { return Color("blPrimaryThemeColor") }
    var secondoryThemeColor: Color { return Color("blSecondoryThemeColor") }
    var bodyTextColor: Color { return Color("blBodyTextColor") }
}

struct Green: ThemeProtocol {
    var primaryThemeColor: Color { return Color("grPrimaryThemeColor") }
    var secondoryThemeColor: Color { return Color("grSecondoryThemeColor") }
    var bodyTextColor: Color { return Color("grBodyTextColor") }
}

