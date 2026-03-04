//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var onboardinVM: OnboardingViewModel
    
    var body: some View {
        switch ( onboardinVM.currentPhase) {
        case .explorePhase : ExplorePetView( )
        case .chooseFurryFriendPhase : ChooseFurryFriendView()
        }
    }
}


#Preview {
    OnboardingView()
}

