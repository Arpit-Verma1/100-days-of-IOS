//
//  ZupetApp.swift
//  Zupet
//
//  Created by Arpit Verma on 2/23/26.
//

import SwiftUI

@main
struct ZupetApp: App {
    
    @StateObject var onboardingVM: OnboardingViewModel = OnboardingViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if onboardingVM.isOnBoardingCompleted {
                    MainTabView()
                        
                } else {
                    OnboardingView()
                        .environmentObject(onboardingVM)
                }
            }
        }
    }
}
