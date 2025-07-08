import Foundation
import FoundationModels
import SwiftUI

// MARK: - Input Models
struct InteriorDesignInput {
    var roomType: RoomType = .livingRoom
    var stylePreference: DesignStyle = .modern
    var colorMood: Double = 0.5 // 0.0 = Warm, 1.0 = Cool
    var budgetRange: BudgetRange = .midRange
    var roomSize: RoomSize = .medium
    var lightingPreference: LightingType = .natural
    var accentColor: String = "#4A90E2"
    var furnitureStyle: FurnitureStyle = .contemporary
}

enum RoomType: String, CaseIterable {
    case livingRoom = "Living Room"
    case bedroom = "Bedroom"
    case kitchen = "Kitchen"
    case office = "Home Office"
    case diningRoom = "Dining Room"
    case bathroom = "Bathroom"
    case nursery = "Nursery"
    case homeGym = "Home Gym"
    
    var icon: String {
        switch self {
        case .livingRoom: return "sofa.fill"
        case .bedroom: return "bed.double.fill"
        case .kitchen: return "stove.fill"
        case .office: return "desktopcomputer"
        case .diningRoom: return "fork.knife"
        case .bathroom: return "shower.fill"
        case .nursery: return "heart.fill"
        case .homeGym: return "dumbbell.fill"
        }
    }
}

enum DesignStyle: String, CaseIterable {
    case modern = "Modern"
    case minimalist = "Minimalist"
    case bohemian = "Bohemian"
    case industrial = "Industrial"
    case scandinavian = "Scandinavian"
    case traditional = "Traditional"
    case coastal = "Coastal"
    case farmhouse = "Farmhouse"
    
    var description: String {
        switch self {
        case .modern: return "Clean lines, neutral colors, and contemporary furniture"
        case .minimalist: return "Simple, clutter-free spaces with essential items only"
        case .bohemian: return "Eclectic mix of colors, textures, and cultural elements"
        case .industrial: return "Raw materials, exposed elements, and urban aesthetic"
        case .scandinavian: return "Light colors, natural materials, and functional design"
        case .traditional: return "Classic elegance with timeless furniture and patterns"
        case .coastal: return "Ocean-inspired colors and relaxed, breezy atmosphere"
        case .farmhouse: return "Rustic charm with modern comfort and vintage touches"
        }
    }
}

enum BudgetRange: String, CaseIterable {
    case budget = "Budget"
    case midRange = "Mid-Range"
    case luxury = "Luxury"
    
    var range: String {
        switch self {
        case .budget: return "$1,000 - $5,000"
        case .midRange: return "$5,000 - $15,000"
        case .luxury: return "$15,000+"
        }
    }
}

enum RoomSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var dimensions: String {
        switch self {
        case .small: return "Under 200 sq ft"
        case .medium: return "200-400 sq ft"
        case .large: return "Over 400 sq ft"
        }
    }
}

enum LightingType: String, CaseIterable {
    case natural = "Natural"
    case ambient = "Ambient"
    case dramatic = "Dramatic"
    case task = "Task Lighting"
    
    var icon: String {
        switch self {
        case .natural: return "sun.max.fill"
        case .ambient: return "lightbulb.fill"
        case .dramatic: return "lightbulb.2.fill"
        case .task: return "lamp.table.fill"
        }
    }
}

enum FurnitureStyle: String, CaseIterable {
    case contemporary = "Contemporary"
    case vintage = "Vintage"
    case rustic = "Rustic"
    case luxury = "Luxury"
    case ecoFriendly = "Eco-Friendly"
}

// MARK: - Generated Design Models
@Generable
struct InteriorDesign: Identifiable {
    var id: String
    @Guide(description: "Design name or title")
    var name: String
    @Guide(description: "Overall design description")
    var description: String
    @Guide(description: "Color palette for the room")
    var colorPalette: [String]
    @Guide(description: "Furniture recommendations")
    var furniture: [FurnitureItem]
    @Guide(description: "Lighting recommendations")
    var lighting: [LightingItem]
    @Guide(description: "Accessories and decor items")
    var accessories: [AccessoryItem]
    @Guide(description: "Layout suggestions")
    var layout: String
    @Guide(description: "Estimated total cost")
    var estimatedCost: String
    @Guide(description: "Design tips and advice")
    var tips: [String]
    
    var swiftUIColorPalette: [Color] {
        colorPalette.compactMap { Color(hex: $0) }
    }
}

@Generable
struct FurnitureItem: Identifiable {
    var id: String
    @Guide(description: "Furniture name")
    var name: String
    @Guide(description: "Furniture type")
    var type: String
    @Guide(description: "Recommended material")
    var material: String
    @Guide(description: "Estimated price range")
    var priceRange: String
    @Guide(description: "Placement suggestion")
    var placement: String
    @Guide(description: "Color recommendation")
    var color: String
}

@Generable
struct LightingItem: Identifiable {
    var id: String
    @Guide(description: "Lighting fixture name")
    var name: String
    @Guide(description: "Lighting type")
    var type: String
    @Guide(description: "Placement location")
    var placement: String
    @Guide(description: "Estimated price")
    var price: String
    @Guide(description: "Lighting effect description")
    var effect: String
}

@Generable
struct AccessoryItem: Identifiable {
    var id: String
    @Guide(description: "Accessory name")
    var name: String
    @Guide(description: "Accessory type")
    var type: String
    @Guide(description: "Placement suggestion")
    var placement: String
    @Guide(description: "Estimated price")
    var price: String
    @Guide(description: "Style notes")
    var styleNotes: String
}



extension FurnitureItem {
    init?(from partial: FurnitureItem.PartiallyGenerated) {
        guard let id = partial.id,
              let name = partial.name,
              let type = partial.type,
              let material = partial.material,
              let priceRange = partial.priceRange,
              let placement = partial.placement,
              let color = partial.color else {
            return nil
        }
        self.init(id: id, name: name, type: type, material: material, priceRange: priceRange, placement: placement, color: color)
    }
}

extension LightingItem {
    init?(from partial: LightingItem.PartiallyGenerated) {
        guard let id = partial.id,
              let name = partial.name,
              let type = partial.type,
              let placement = partial.placement,
              let price = partial.price,
              let effect = partial.effect else {
            return nil
        }
        self.init(id: id, name: name, type: type, placement: placement, price: price, effect: effect)
    }
}

extension AccessoryItem {
    init?(from partial: AccessoryItem.PartiallyGenerated) {
        guard let id = partial.id,
              let name = partial.name,
              let type = partial.type,
              let placement = partial.placement,
              let price = partial.price,
              let styleNotes = partial.styleNotes else {
            return nil
        }
        self.init(id: id, name: name, type: type, placement: placement, price: price, styleNotes: styleNotes)
    }
}

// MARK: - Generation Process Models
struct GenerationStep: Identifiable {
    let id = UUID()
    let step: String
    let message: String
    let timestamp: Date
    let type: StepType
    var isCompleted: Bool = false
    
    enum StepType {
        case thinking
        case analyzing
        case generating
        case refining
        case completed
        
        var icon: String {
            switch self {
            case .thinking: return "brain.head.profile"
            case .analyzing: return "magnifyingglass"
            case .generating: return "sparkles"
            case .refining: return "paintbrush"
            case .completed: return "checkmark.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .thinking: return .blue
            case .analyzing: return .orange
            case .generating: return .purple
            case .refining: return .green
            case .completed: return .green
            }
        }
    }
}

struct ThinkingProcess {
    var steps: [GenerationStep] = []
    var currentStep: GenerationStep?
    var isComplete: Bool = false
    
    mutating func addStep(_ step: GenerationStep) {
        steps.append(step)
        currentStep = step
    }
    
    mutating func completeCurrentStep() {
        if let index = steps.lastIndex(where: { $0.id == currentStep?.id }) {
            steps[index].isCompleted = true
        }
    }
}

// MARK: - Terminal Log Models
struct TerminalLog: Identifiable {
    let id = UUID()
    let message: String
    let timestamp: Date
    let level: LogLevel
    
    enum LogLevel {
        case info
        case thinking
        case generating
        case success
        case error
        
        var prefix: String {
            switch self {
            case .info: return "ℹ️"
            case .thinking: return "🧠"
            case .generating: return "✨"
            case .success: return "✅"
            case .error: return "❌"
            }
        }
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .thinking: return .purple
            case .generating: return .orange
            case .success: return .green
            case .error: return .red
            }
        }
    }
}
