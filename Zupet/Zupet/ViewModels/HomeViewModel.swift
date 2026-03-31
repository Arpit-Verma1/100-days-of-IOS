import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var selectedCategory: PetCategoryType = .cats
    @Published var pets: [PetItem] = []
    
    init() {
        loadMockPets()
    }
    
    var filteredPets: [PetItem] {
        if selectedCategory == .all {
            return pets
        }
        return pets.filter { $0.category == selectedCategory }
    }
    
    private func loadMockPets() {
        pets = PetItem.samplePets
    }
}
