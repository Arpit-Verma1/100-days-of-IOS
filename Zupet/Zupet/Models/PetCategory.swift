import Foundation
import SwiftUI


struct PetItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let ageDescription: String
    let gender: String
    let distanceText: String
    let imageName: String
    let category: PetCategoryType
    let color: Color
    var description: String?
    var breed: String?
    var attributeTags: [String]
    var videoNames: [String]

    init(
        name: String,
        ageDescription: String,
        gender: String,
        distanceText: String,
        imageName: String,
        category: PetCategoryType,
        description: String? = nil,
        breed: String? = nil,
        attributeTags: [String] = [],
        videoNames: [String] = [],
        color: Color
    ) {
        self.name = name
        self.ageDescription = ageDescription
        self.gender = gender
        self.distanceText = distanceText
        self.imageName = imageName
        self.category = category
        self.description = description
        self.breed = breed
        self.attributeTags = attributeTags
        self.videoNames = videoNames
        self.color = color
    }
    
    static let samplePets: [PetItem] = [
        PetItem(
            name: "Milo Meow",
            ageDescription: "2 Years",
            gender: "Male",
            distanceText: "2km",
            imageName: "cat1",
            category: .cats,
            description: "Milo is cool, he likes to make friends. It'd be great if you rub his belly and feed him.",
            breed: "Maine Coon",
            attributeTags: ["Friendly", "Playful", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe1
        ),
        PetItem(
            name: "Luna",
            ageDescription: "1 Year",
            gender: "Female",
            distanceText: "3km",
            imageName: "cat2",
            category: .cats,
            description: "Luna is shy but loving. She loves treats and quiet cuddles.",
            breed: "British Shorthair",
            attributeTags: ["Calm", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe2
        ),PetItem(
            name: "Leo",
            ageDescription: "1 Year",
            gender: "Female",
            distanceText: "3km",
            imageName: "cat3",
            category: .cats,
            description: "Leo is shy but loving. She loves treats and quiet cuddles.",
            breed: "British Shorthair",
            attributeTags: ["Calm", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe3
        ),
        PetItem(
            name: "Bella",
            ageDescription: "1 Year",
            gender: "Female",
            distanceText: "3km",
            imageName: "cat4",
            category: .cats,
            description: "Bella is shy but loving. She loves treats and quiet cuddles.",
            breed: "Ragdoll",
            attributeTags: ["Calm", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe4
        ),
        PetItem(
            name: "Mapel",
            ageDescription: "2 Years",
            gender: "Male",
            distanceText: "1km",
            imageName: "dog1",
            category: .dogs,
            description: "Mapel is a cool and gentle soul who loves making new friends wherever he goes. He enjoys belly rubs, tasty treats, and being around people who give him love and attention. His playful nature and loving personality make him the perfect companion for cozy evenings and happy adventures.",
            breed: "Beagle",
            attributeTags: ["Friendly", "Lazy", "Vaccinated"],
            videoNames: ["beagle1", "beagle2"],
            color: Color.theme.petStripe1
        ),
        PetItem(
            name: "Coco",
            ageDescription: "3 Years",
            gender: "Female",
            distanceText: "5km",
            imageName: "dog2",
            category: .dogs,
            description: "Coco is energetic and loves long walks.",
            breed: "Beagle",
            attributeTags: ["Friendly", "Active", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe2
        ),
        PetItem(
            name: "Rocky",
            ageDescription: "4 Years",
            gender: "Male",
            distanceText: "1.5km",
            imageName: "dog3",
            category: .dogs,
            description: "Rocky is a loyal companion. He's great with kids.",
            breed: "Yorkshire Terrier",
            attributeTags: ["Loyal", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe3
        ),
        PetItem(
            name: "Rocky",
            ageDescription: "4 Years",
            gender: "Male",
            distanceText: "1.5km",
            imageName: "dog4",
            category: .dogs,
            description: "Rocky is a loyal companion. He's great with kids.",
            breed: "Pub",
            attributeTags: ["Loyal", "Vaccinated"],
            videoNames: [],
            color: Color.theme.petStripe4
        )
    ]

}

enum PetCategoryType: String, CaseIterable, Identifiable {
    case all
    case cats
    case dogs
    case birds
    case fish
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .cats: return "Cats"
        case .dogs: return "Dogs"
        case .birds: return "Birds"
        case .fish: return "Fish"
        }
    }
    
    var iconName: String {
        switch self {
        case .all: return "pawprint.fill"
        case .cats: return "cat_icon"
        case .dogs: return "dog_icon"
        case .birds: return "bird_icon"
        case .fish: return "fish_icon"
        }
    }
    var height: Double {
        switch self {
        case .all: return 40
        case .cats: return 40
        case .dogs: return 35
        case .birds: return 45
        case .fish: return 40
        }
    }
}
