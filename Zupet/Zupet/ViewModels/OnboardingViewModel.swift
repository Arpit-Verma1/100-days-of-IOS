import Foundation
import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isOnBoardingCompleted: Bool = false
    @Published var currentPhase: OnboardingPhase = .explorePhase
    @Published var samplePets: [Pet] = [
        Pet(
            name: "Coco",
            imageName: "pet_coco",
            stripeColor: Color.theme.petStripe1,
            height: 450,
        ),
        Pet(
            name: "Milo",
            imageName: "pet_milo",
            stripeColor: Color.theme.petStripe2,
            height: 550,
        ),
        Pet(
            name: "Rocky",
            imageName: "pet_rocky",
            stripeColor: Color.theme.petStripe3,
            height: 400,
        ),
        Pet(
            name: "Luna",
            imageName: "pet_luna",
            stripeColor: Color.theme.petStripe4,
            height: 450,
        )
    ]
    
    func didTapExplore() {
        // Navigation from onboarding will be wired later
    }
}

enum OnboardingPhase {
    case explorePhase
    case chooseFurryFriendPhase
}
