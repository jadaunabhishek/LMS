//
//  Tips.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 09/05/24.
//

import Foundation
import TipKit

struct identifyTip: Tip {
    var title: Text {
        Text("Identify")
    }
    var message: Text? {
        Text("Scan your skin to detect acne and other issues quickly and accurately.")
    }
    var image: Image? {
        Image(systemName: "magnifyingglass")
    }
}

struct diagnoseTip: Tip {
    var title: Text {
        Text("Diagnose")
    }
    var message: Text? {
        Text("Consult with dermatologists to get professional advice.")
    }
    var image: Image? {
        Image(systemName: "person.fill.questionmark")
    }
}

struct prescribeTip: Tip {
    var title: Text {
        Text("Prescribe")
    }
    var message: Text? {
        Text("Receive prescriptions tailored to your skin's needs.")
    }
    var image: Image? {
        Image(systemName: "pills.fill")
    }
}

struct profileTip: Tip {
    @EnvironmentObject var themeManager: ThemeManager
    var title: Text {
        Text("Procedure")
    }
    var message: Text? {
        Text("In the 'Diagnose' tab, identify your acne and consult with a doctor based on the app's analysis. Then, in 'Prescription', get personalized treatment plans prescribed by your doctor.")
    }
    var image: Image? {
        Image(systemName: "exclamationmark.square.fill")
    }
}

