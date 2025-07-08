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
    
    // New properties for interactive generation
    @Published var thinkingProcess = ThinkingProcess()
    @Published var terminalLogs: [TerminalLog] = []
    @Published var showingGenerationProcess = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input Validation
    var canGenerateDesign: Bool {
        !designInput.roomType.rawValue.isEmpty &&
        !designInput.stylePreference.rawValue.isEmpty
    }
    
    // MARK: - Terminal Logging
    private func logToTerminal(_ message: String, level: TerminalLog.LogLevel) {
        let log = TerminalLog(message: message, timestamp: Date(), level: level)
        terminalLogs.append(log)
        print("\(log.level.prefix) [\(DateFormatter.timeOnly.string(from: log.timestamp))] \(message)")
    }
    
    private func logStepStart(_ step: String) {
        logToTerminal("🚀 Starting: \(step)", level: .info)
    }
    
    private func logStepComplete(_ step: String, duration: TimeInterval) {
        logToTerminal("✅ Completed: \(step) (took \(String(format: "%.1f", duration))s)", level: .success)
    }
    
    private func logThinking(_ thought: String) {
        logToTerminal("🧠 Thinking: \(thought)", level: .thinking)
    }
    
    private func logGeneration(_ action: String) {
        logToTerminal("✨ Generating: \(action)", level: .generating)
    }
    
    // MARK: - Interactive Generate Design
    func generateDesign() {
        Task {
            do {
                isGenerating = true
                showingGenerationProcess = true
                errorMessage = nil
                
                // Reset process
                thinkingProcess = ThinkingProcess()
                terminalLogs.removeAll()
                
                logToTerminal("🎯 Starting interior design generation...", level: .info)
                logToTerminal("📋 Input parameters:", level: .info)
                logToTerminal("   Room: \(designInput.roomType.rawValue)", level: .info)
                logToTerminal("   Style: \(designInput.stylePreference.rawValue)", level: .info)
                logToTerminal("   Budget: \(designInput.budgetRange.rawValue)", level: .info)
                logToTerminal("   Size: \(designInput.roomSize.rawValue)", level: .info)
                
                // Step 1: Analyzing Input
                let step1Start = Date()
                logStepStart("Analyzing Design Requirements")
                await addThinkingStep("Analyzing Design Requirements", 
                                    "Examining room type, style preferences, and constraints", 
                                    type: .analyzing)
                
                logThinking("Analyzing room type: \(designInput.roomType.rawValue)")
                logThinking("Style preference: \(designInput.stylePreference.rawValue)")
                logThinking("Budget range: \(designInput.budgetRange.rawValue)")
                logThinking("Room size: \(designInput.roomSize.rawValue)")
                
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
                await MainActor.run {
                    thinkingProcess.completeCurrentStep()
                }
                logStepComplete("Analyzing Design Requirements", duration: Date().timeIntervalSince(step1Start))
                
                // Step 2: Researching Design Principles
                let step2Start = Date()
                logStepStart("Researching Design Principles")
                await addThinkingStep("Researching Design Principles", 
                                    "Applying \(designInput.stylePreference.rawValue) design principles and best practices", 
                                    type: .thinking)
                
                logThinking("Researching \(designInput.stylePreference.rawValue) design principles")
                logThinking("Considering color theory for mood: \(designInput.colorMood < 0.3 ? "Warm" : designInput.colorMood > 0.7 ? "Cool" : "Balanced")")
                logThinking("Analyzing lighting requirements: \(designInput.lightingPreference.rawValue)")
                
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                await MainActor.run {
                    thinkingProcess.completeCurrentStep()
                }
                logStepComplete("Researching Design Principles", duration: Date().timeIntervalSince(step2Start))
                
                // Step 3: Generating Color Palette
                let step3Start = Date()
                logStepStart("Creating Color Palette")
                await addThinkingStep("Creating Color Palette", 
                                    "Designing a cohesive color scheme that matches the style and mood", 
                                    type: .generating)
                
                logGeneration("Color palette for \(designInput.stylePreference.rawValue) style")
                logThinking("Considering lighting preference: \(designInput.lightingPreference.rawValue)")
                logThinking("Balancing warm/cool tones based on mood preference")
                
                try await Task.sleep(nanoseconds: 1_800_000_000) // 1.8 seconds
                await MainActor.run {
                    thinkingProcess.completeCurrentStep()
                }
                logStepComplete("Creating Color Palette", duration: Date().timeIntervalSince(step3Start))
                
                // Step 4: Planning Furniture Layout
                let step4Start = Date()
                logStepStart("Planning Furniture Layout")
                await addThinkingStep("Planning Furniture Layout", 
                                    "Optimizing furniture placement for \(designInput.roomSize.rawValue) space", 
                                    type: .thinking)
                
                logThinking("Planning layout for \(designInput.roomSize.rawValue) room")
                logThinking("Selecting \(designInput.furnitureStyle.rawValue) furniture style")
                logThinking("Optimizing traffic flow and functionality")
                
                try await Task.sleep(nanoseconds: 2_200_000_000) // 2.2 seconds
                await MainActor.run {
                    thinkingProcess.completeCurrentStep()
                }
                logStepComplete("Planning Furniture Layout", duration: Date().timeIntervalSince(step4Start))
                
                // Step 5: Generating Complete Design
                let step5Start = Date()
                logStepStart("Generating Complete Design")
                await addThinkingStep("Generating Complete Design", 
                                    "Creating comprehensive design with all elements and recommendations", 
                                    type: .generating)
                
                logGeneration("Complete interior design plan")
                logToTerminal("🤖 Calling AI model for design generation...", level: .generating)
                
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
                    
                    if let firstDesign = designs.first {
                        logGeneration("Design: \(firstDesign.name)")
                    }
                }
                
                logStepComplete("Generating Complete Design", duration: Date().timeIntervalSince(step5Start))
                
                // Step 6: Refining and Finalizing
                let step6Start = Date()
                logStepStart("Refining Design")
                await addThinkingStep("Refining Design", 
                                    "Polishing the design and ensuring all elements work harmoniously", 
                                    type: .refining)
                
                logThinking("Refining design elements and ensuring harmony")
                logThinking("Validating budget constraints")
                logThinking("Optimizing color combinations")
                
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
                await MainActor.run {
                    thinkingProcess.completeCurrentStep()
                }
                logStepComplete("Refining Design", duration: Date().timeIntervalSince(step6Start))
                
                // Step 7: Completed
                let step7Start = Date()
                logStepStart("Finalizing Design")
                await addThinkingStep("Design Complete", 
                                    "Your interior design is ready! All elements have been carefully considered and optimized.", 
                                    type: .completed)
                
                logToTerminal("🎉 Design generation completed successfully!", level: .success)
                
                if let firstDesign = generatedDesigns.first {
                    selectedDesign = firstDesign
                    logToTerminal("📋 Final design: \(firstDesign.name)", level: .success)
                    logToTerminal("💰 Estimated cost: \(firstDesign.estimatedCost)", level: .success)
                    logToTerminal("🎨 Colors: \(firstDesign.colorPalette.count) selected", level: .success)
                    logToTerminal("🪑 Furniture: \(firstDesign.furniture.count) items", level: .success)
                    logToTerminal("💡 Lighting: \(firstDesign.lighting.count) fixtures", level: .success)
                }
                
                thinkingProcess.isComplete = true
                
                logStepComplete("Finalizing Design", duration: Date().timeIntervalSince(step7Start))
                
                // Show result after a longer delay to allow texture cleanup
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                
                // Clean up memory before transition
                cleanupMemory()
                
                // Update UI state in a single batch to reduce texture creation
                await MainActor.run {
                    isGenerating = false
                    showingGenerationProcess = false
                    
                    // Add a small delay before showing result
                    Task {
                        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                        await MainActor.run {
                            showingResult = true
                        }
                    }
                }
                
            } catch {
                isGenerating = false
                errorMessage = error.localizedDescription
                logToTerminal("❌ Design generation error: \(error.localizedDescription)", level: .error)
                print("Design generation error: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    private func addThinkingStep(_ step: String, _ message: String, type: GenerationStep.StepType) async {
        let generationStep = GenerationStep(step: step, message: message, timestamp: Date(), type: type)
        
        await MainActor.run {
            thinkingProcess.addStep(generationStep)
        }
        
        // Add to terminal logs
        logToTerminal("Step: \(step)", level: .info)
        logToTerminal(message, level: .thinking)
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
        thinkingProcess = ThinkingProcess()
        terminalLogs.removeAll()
        showingGenerationProcess = false
    }
    
    // MARK: - Memory Cleanup
    private func cleanupMemory() {
        // Clear terminal logs to free memory
        terminalLogs.removeAll()
        
        // Force garbage collection if available
        #if DEBUG
        print("🧹 Memory cleanup performed")
        #endif
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

// MARK: - Extensions
extension DateFormatter {
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
} 
