//
//  Tips.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 09/05/24.
//

import Foundation
import TipKit


struct borrowTip: Tip {
    @EnvironmentObject var themeManager: ThemeManager
    var title: Text {
        Text("Book")
    }
    var message: Text? {
        Text("Tap here to borrow this book.")
    }
    var image: Image? {
        Image(systemName: "checkmark.seal.fill")
    }
}

struct preBookTip: Tip {
    @EnvironmentObject var themeManager: ThemeManager
    var title: Text {
        Text("Pre Book")
    }
    var message: Text? {
        Text("Tap here to Pre Book this book.")
    }
    var image: Image? {
        Image(systemName: "checkmark.seal.fill")
    }
}

struct welcomingTip: Tip {
    @EnvironmentObject var themeManager: ThemeManager
    var title: Text {
        Text("Discover & Organize")
    }
    var message: Text? {
        Text("Welcome to Trove, your ultimate library app! 📚✨ Dive into our collection and discover literary treasures. Happy exploring!")
    }
}

struct customizeTip: Tip {
    @EnvironmentObject var themeManager: ThemeManager
    var title: Text {
        Text("Customize Your Trove!")
    }
    var message: Text? {
        Text("Customize your Trove experience! 🎨✨ Personalize your app's theme and brand logo to reflect your unique style.")
    }
}

