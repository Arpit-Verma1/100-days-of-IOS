//
//  chatBotApp.swift
//  chatBot
//
//  Created by Arpit Verma on 7/9/25.
//

import SwiftUI
import FoundationModels
import Combine

@main
struct chatBotApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ChatView()
                .environmentObject(appState)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // No need to initialize AIService or FoundationModels
        print("🚀 Document ChatBot starting...")
    }
}

// MARK: - App State
@MainActor
class AppState: ObservableObject {
    @Published var isAIModelReady = false
    @Published var appVersion = "1.0.0"
}
