//
//  CowAndBullsApp.swift
//  CowAndBulls
//
//  Created by Akshat Gandhi on 03/01/25.
//

import SwiftUI

@main
struct CowAndBullsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings(content: SettingsView.init)
    }
}
