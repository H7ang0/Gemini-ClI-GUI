//
//  GeminiGUIApp.swift
//  GeminiGUI
//
//  Created by H7ang0 on 9/9/25.
//

import SwiftUI

@main
struct GeminiGUIApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }

        // Add the settings scene
        Settings {
            SettingsMainView()
        }
    }
}
