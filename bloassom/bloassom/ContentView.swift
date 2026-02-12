//
//  ContentView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView(showHome: $hasCompletedOnboarding) {
                hasCompletedOnboarding = true
            }
        }
        
    }
}

#Preview {
    ContentView()
}
