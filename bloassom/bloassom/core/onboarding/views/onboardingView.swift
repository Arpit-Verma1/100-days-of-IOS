//
//  onboardingView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/5/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var showHome: Bool
    var onGetStarted: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Image("background")
                    .resizable()
                    .opacity(0.75)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Blossom")
                        .font(.custom("KGAlwaysAGoodTime", size: 46))
                        .foregroundStyle(Color.theme.textColor)
                        .multilineTextAlignment(.center)
                    
                    Text("In joy or sadness, Flowers are our constant friends.")
                        .font(.typography.body)
                        .foregroundStyle(Color.theme.subTitleTexColor)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    PrimaryCapsuleButton(title: "GET STARTED") {
                        onGetStarted?()
                    }
                    
                    
                }
                .padding(.horizontal, 100)
                .padding(.bottom , 50)
                
            }
            .navigationDestination(isPresented: $showHome) {
                MainTabView()
            }
            
        }
        
    }
}


#Preview("Onboarding View") {
    OnboardingView(showHome: .constant(false)) {
        
    }
}
