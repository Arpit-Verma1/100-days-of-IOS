//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI
import Combine

struct ExplorePetView: View {
    @EnvironmentObject var onboardinVM: OnboardingViewModel
    
    var body: some View {
        ZStack {
           Image("explorePageBackground")
                .resizable()
                .opacity(0.4)
                .frame(maxWidth: .infinity)
            
            VStack {
                Spacer(minLength: 40)
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(onboardinVM.samplePets.enumerated()), id: \.element.id) { index, pet in
                        PetStripeView(pet: pet, index: index)
                            .frame(maxWidth: .infinity)
                            .frame(height: pet.height)
                            .offset(y: -(pet.height * 0.1))
                    }
                }
                .frame(maxWidth: .infinity)
                .offset(y : -150)
                
                VStack(spacing: 12) {
                    Text("Adopt your the best friend")
                        .font(.custom("HollaBear-Regular", size: 35))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color.theme.textColor)
                    
                    Text("Adoption saves a friend today and makes room for another tomorrow.")
                        .font(Font.typography.body)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color.theme.secondaryText)
                }
               
                .padding(.horizontal, 32)
                
                Spacer()
                    .frame(height: 40)
                Button(action: {
                    onboardinVM.currentPhase = .chooseFurryFriendPhase
                }) {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .fill(Color.theme.textColor)
                            .offset(x: 3, y: 4)
                        
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .fill(Color.theme.petStripe2)
                        
                        Text("Explore")
                            .font(Font.typography.calloutMedium)
                            .foregroundColor(Color.theme.textColor)
                            .padding(.vertical, 16)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 32)
            }
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
}

