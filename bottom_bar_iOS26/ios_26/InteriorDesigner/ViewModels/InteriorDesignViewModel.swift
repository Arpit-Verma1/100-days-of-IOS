import SwiftUI
import FoundationModels
import Combine

@MainActor
class InteriorDesignViewModel: ObservableObject {
    @Published var designInput = InteriorDesignInput()
    @Published var generatedDesigns: [InteriorDesign] = []
    @Published var isGenerating = false
    @Published var selectedDesign: InteriorDesign?
    @Published var showingResult = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input Validation
    var canGenerateDesign: Bool {
        !designInput.roomType.rawValue.isEmpty &&
        !designInput.stylePreference.rawValue.isEmpty
    }
    
    // MARK: - Generate Design
    func generateDesign() {
        Task {
            do {
                isGenerating = true
                errorMessage = nil
                
                let instruction = """
                Create a comprehensive interior design plan for a \(designInput.roomType.rawValue) with \(designInput.stylePreference.rawValue) style. 
                Consider the following specifications:
                - Budget Range: \(designInput.budgetRange.rawValue) (\(designInput.budgetRange.range))
                - Room Size: \(designInput.roomSize.rawValue) (\(designInput.roomSize.dimensions))
                - Lighting Preference: \(designInput.lightingPreference.rawValue)
                - Color Mood: \(designInput.colorMood < 0.3 ? "Warm" : designInput.colorMood > 0.7 ? "Cool" : "Balanced")
                - Furniture Style: \(designInput.furnitureStyle.rawValue)
                
                Generate a complete design including:
                1. A creative design name
                2. Detailed description of the overall aesthetic
                3. A cohesive color palette (5-7 colors in hex format)
                4. Specific furniture recommendations with materials and placement
                5. Lighting solutions for the space
                6. Accessories and decor items
                7. Layout suggestions
                8. Estimated total cost
                9. Practical design tips
                
                Make the design practical, beautiful, and within the specified budget range.
                """
                
                let session = LanguageModelSession { instruction }
                let response = session.streamResponse(to: "", generating: [InteriorDesign].self)
                
                for try await partialResult in response {
                    let designs = partialResult.compactMap {
                        if let id = $0.id,
                           let name = $0.name,
                           let description = $0.description,
                           let colorPalette = $0.colorPalette,
                           let furniture = $0.furniture?.compactMap { FurnitureItem(from: $0) },
                           let lighting = $0.lighting?.compactMap { LightingItem(from: $0) },
                           let accessories = $0.accessories?.compactMap { AccessoryItem(from: $0) },
                         let layout = $0.layout,
                           let estimatedCost = $0.estimatedCost,
                           let tips = $0.tips {
                            return InteriorDesign(id: id,
                                name: name,
                                description: description,
                                colorPalette: colorPalette,
                                furniture:furniture,
                                lighting:lighting,
                                accessories: accessories,
                                layout: layout,
                                estimatedCost: estimatedCost,
                                tips: tips)
                    }
                            else {
                            return nil
                        }
                    }
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.generatedDesigns = designs
                    }
                }
                
                if let firstDesign = generatedDesigns.first {
                    selectedDesign = firstDesign
                    showingResult = true
                }
                
                isGenerating = false
                
            } catch {
                isGenerating = false
                errorMessage = error.localizedDescription
                print("Design generation error: \(error)")
            }
        }
    }
    
    // MARK: - Design Selection
    func selectDesign(_ design: InteriorDesign) {
        selectedDesign = design
        showingResult = true
    }
    
    // MARK: - Reset
    func resetDesign() {
        designInput = InteriorDesignInput()
        generatedDesigns = []
        selectedDesign = nil
        showingResult = false
        errorMessage = nil
    }
    
    // MARK: - Color Mood Helper
    var colorMoodDescription: String {
        switch designInput.colorMood {
        case 0.0..<0.3:
            return "Warm & Cozy"
        case 0.3..<0.7:
            return "Balanced"
        default:
            return "Cool & Calm"
        }
    }
    
    var colorMoodColor: Color {
        switch designInput.colorMood {
        case 0.0..<0.3:
            return .orange
        case 0.3..<0.7:
            return .green
        default:
            return .blue
        }
    }
} 
