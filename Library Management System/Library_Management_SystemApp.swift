//
//  Library_Management_SystemApp.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI
import Firebase

@main
struct Library_Management_SystemApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init(){
        FirebaseApp.configure()
    }
}
