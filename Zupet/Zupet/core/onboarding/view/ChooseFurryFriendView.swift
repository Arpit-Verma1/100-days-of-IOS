//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI

struct ChooseFurryFriendView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            VStack(alignment: .leading, spacing: 8) {
                Text("Find Your")
                Text("Furry")
                Text("Favorite")
            }
            .font(.custom("HollaBear-Regular", size: 34))
            .foregroundColor(Color.theme.textColor)
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .animation(
                .spring(response: 0.6, dampingFraction: 0.85),
                value: animate
            )

            ZStack {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Find your perfect pet\ncompanion")
                            .font(Font.typography.title3Bold)
                            .foregroundColor(Color.theme.textColor)
                        
                        PawSliderView(title: "Get Started") {
                            onboardingVM.isOnBoardingCompleted = true
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 0, style: .continuous)
                            .fill(Color.white)
                    )
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 24)
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.85)
                            .delay(0.15),
                        value: animate
                    )
                }
                Image("monkey")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 650)
                    .allowsHitTesting(false)
                    .scaleEffect(animate ? 1 : 0.9, anchor: .bottom)
                    .opacity(animate ? 1 : 0)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.8)
                            .delay(0.05),
                        value: animate
                    )
            }
        }
        .background(
            Color.theme.petStripe2
                .opacity(0.2)
                .ignoresSafeArea(.all)
        )
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ChooseFurryFriendView()
}

