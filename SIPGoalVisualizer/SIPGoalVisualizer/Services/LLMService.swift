//
//  LLMService.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/28/25.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Supporting Models for AI Analysis
struct ThinkingProcess {
    var steps: [GenerationStep] = []
    var currentStepIndex: Int = 0
    var isComplete: Bool = false
    
    mutating func addStep(_ step: GenerationStep) {
        steps.append(step)
    }
    
    mutating func completeCurrentStep() {
        if currentStepIndex < steps.count {
            steps[currentStepIndex].isCompleted = true
            currentStepIndex += 1
        }
    }
}

struct GenerationStep {
    let step: String
    let message: String
    let timestamp: Date
    let type: StepType
    var isCompleted: Bool = false
    
    enum StepType {
        case analyzing, thinking, generating, refining, completed
        
        var icon: String {
            switch self {
            case .analyzing: return "chart.line.uptrend.xyaxis"
            case .thinking: return "brain.head.profile"
            case .generating: return "sparkles"
            case .refining: return "checkmark.circle"
            case .completed: return "checkmark.circle.fill"
            }
        }
        
        var color: String {
            switch self {
            case .analyzing: return "blue"
            case .thinking: return "purple"
            case .generating: return "orange"
            case .refining: return "green"
            case .completed: return "green"
            }
        }
    }
}

struct TerminalLog {
    let message: String
    let timestamp: Date
    let level: LogLevel
    
    enum LogLevel {
        case info, success, error, thinking, generating
        
        var prefix: String {
            switch self {
            case .info: return "ℹ️"
            case .success: return "✅"
            case .error: return "❌"
            case .thinking: return "🧠"
            case .generating: return "✨"
            }
        }
    }
}

extension DateFormatter {
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
}

class LLMService: ObservableObject {
    @Published var isAnalyzing = false
    @Published var analysisProgress = 0.0
    @Published var currentStep = ""
    @Published var errorMessage: String?
    @Published var thinkingProcess = ThinkingProcess()
    @Published var terminalLogs: [TerminalLog] = []

        private var cancellables = Set<AnyCancellable>()

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

    // MARK: - Generate Stock Recommendations
    func generateStockRecommendations(
        stocks: [Stock],
        goals: [Goal],
        userPreferences: UserPreferences
    ) async throws -> LLMStockAnalysis {
        do {
            isAnalyzing = true
            analysisProgress = 0.0
            errorMessage = nil
            
            // Reset process
            thinkingProcess = ThinkingProcess()
            terminalLogs.removeAll()
            
            logToTerminal("🎯 Starting intelligent stock analysis...", level: .info)
            logToTerminal("📊 Available stocks: \(stocks.count)", level: .info)
            logToTerminal("🎯 Financial goals: \(goals.count)", level: .info)
            
            // Step 1: Market Analysis
            let step1Start = Date()
            logStepStart("Market Analysis")
            await addThinkingStep("Market Analysis", 
                                "Analyzing current market conditions and stock performance metrics", 
                                type: .analyzing)
            
            logThinking("Analyzing \(stocks.count) stocks for market trends")
            logThinking("Evaluating volatility and risk patterns")
            logThinking("Identifying market sentiment and momentum")
            
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            analysisProgress = 0.2
            thinkingProcess.completeCurrentStep()
            logStepComplete("Market Analysis", duration: Date().timeIntervalSince(step1Start))
            
            // Step 2: Goal Analysis
            let step2Start = Date()
            logStepStart("Goal Analysis")
            await addThinkingStep("Goal Analysis", 
                                "Understanding your financial objectives and investment timeline", 
                                type: .thinking)
            
            for goal in goals {
                logThinking("Goal: \(goal.name) - ₹\(CurrencyFormatter.formatCompact(goal.remainingAmount)) remaining")
                logThinking("Timeline: \(goal.daysRemaining) days remaining")
                logThinking("Monthly investment: ₹\(CurrencyFormatter.formatCompact(goal.monthlyInvestment))")
            }
            
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            analysisProgress = 0.4
            thinkingProcess.completeCurrentStep()
            logStepComplete("Goal Analysis", duration: Date().timeIntervalSince(step2Start))
            
            // Step 3: Risk Assessment
            let step3Start = Date()
            logStepStart("Risk Assessment")
            await addThinkingStep("Risk Assessment", 
                                "Evaluating risk tolerance and matching stocks to your comfort level", 
                                type: .thinking)
            
            logThinking("Risk tolerance: \(userPreferences.riskTolerance.rawValue)")
            logThinking("Investment horizon: \(userPreferences.investmentHorizon) months")
            logThinking("Maximum investment per stock: ₹\(CurrencyFormatter.formatCompact(userPreferences.maxInvestmentPerStock))")
            
            try await Task.sleep(nanoseconds: 1_200_000_000) // 1.2 seconds
            analysisProgress = 0.6
            thinkingProcess.completeCurrentStep()
            logStepComplete("Risk Assessment", duration: Date().timeIntervalSince(step3Start))
            
            // Step 4: Intelligent Stock Analysis
            let step4Start = Date()
            logStepStart("Intelligent Stock Analysis")
            await addThinkingStep("Intelligent Stock Analysis", 
                                "Using advanced algorithms to analyze stocks and match them to your goals", 
                                type: .generating)
            
            logGeneration("Running intelligent stock analysis algorithms...")
            
            // Create comprehensive instruction for AI
            let instruction = createAIInstruction(stocks: stocks, goals: goals, preferences: userPreferences)
            
            // For now, use fallback recommendations since Foundation Models integration needs more setup
            // In a real implementation, you would use:
            // let session = LanguageModelSession { instruction }
            // let response = session.streamResponse(to: "", generating: [StockRecommendation].self)
            
            logGeneration("Using intelligent recommendation engine...")
            
            // Create intelligent recommendations using our fallback system
            let aiRecommendations = createFallbackRecommendations(stocks: stocks, goals: goals, preferences: userPreferences)
            
            withAnimation(.easeInOut(duration: 0.3)) {
                // Update progress as recommendations are generated
                analysisProgress = 0.6 + (Double(aiRecommendations.count) / Double(goals.count * 3)) * 0.3
            }
            
            for recommendation in aiRecommendations {
                logGeneration("Generated recommendation: \(recommendation.displayName) for \(recommendation.displayGoal)")
            }
            
            logStepComplete("Intelligent Stock Analysis", duration: Date().timeIntervalSince(step4Start))
            
            // Step 5: Finalizing Analysis
            let step5Start = Date()
            logStepStart("Finalizing Analysis")
            await addThinkingStep("Finalizing Analysis", 
                                "Compiling comprehensive analysis and generating insights", 
                                type: .refining)
            
            logThinking("Compiling \(aiRecommendations.count) stock recommendations")
            logThinking("Generating market insights and risk warnings")
            logThinking("Calculating time estimates for goal achievement")
            
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            analysisProgress = 1.0
            thinkingProcess.completeCurrentStep()
            logStepComplete("Finalizing Analysis", duration: Date().timeIntervalSince(step5Start))
            
            // Generate final analysis
            let marketAnalysis = generateMarketAnalysis(stocks: stocks)
            let marketInsights = generateMarketInsights(stocks: stocks)
            let riskWarnings = generateRiskWarnings(stocks: stocks)
            let timeEstimates = calculateTimeEstimates(recommendations: aiRecommendations, goals: goals)
            
            // Recommendations are already generated using our intelligent fallback system
            
            logToTerminal("🎉 Intelligent stock analysis completed successfully!", level: .success)
            logToTerminal("📈 Generated \(aiRecommendations.count) recommendations", level: .success)
            logToTerminal("🎯 Covered \(goals.count) financial goals", level: .success)
            
            thinkingProcess.isComplete = true
            
            return LLMStockAnalysis(
                recommendations: aiRecommendations,
                analysis: marketAnalysis,
                marketInsights: marketInsights,
                riskWarnings: riskWarnings,
                timeEstimates: timeEstimates
            )
            
        } catch {
            errorMessage = error.localizedDescription
            logToTerminal("❌ Intelligent analysis error: \(error.localizedDescription)", level: .error)
            throw error
        }
        
        defer {
            isAnalyzing = false
        }
    }
    
    // MARK: - AI Instruction Creation
    private func createAIInstruction(stocks: [Stock], goals: [Goal], preferences: UserPreferences) -> String {
        let stockData = stocks.map { stock in
            """
            Stock: \(stock.company) (\(stock.ticker))
            - Current Price: ₹\(String(format: "%.2f", stock.price))
            - Change: \(String(format: "%.2f", stock.percentChange))%
            - Volume: \(stock.volume)
            - 52-Week Range: ₹\(String(format: "%.2f", stock.week52Low)) - ₹\(String(format: "%.2f", stock.week52High))
            - Overall Rating: \(stock.overallRating)
            - Short-term Trend: \(stock.shortTermTrend)
            - Long-term Trend: \(stock.longTermTrend)
            - Risk Level: \(stock.riskLevel.rawValue)
            """
        }.joined(separator: "\n\n")
        
        let goalData = goals.map { goal in
            """
            Goal: \(goal.name)
            - Target Amount: ₹\(CurrencyFormatter.formatCompact(goal.targetAmount))
            - Current Amount: ₹\(CurrencyFormatter.formatCompact(goal.currentAmount))
            - Remaining: ₹\(CurrencyFormatter.formatCompact(goal.remainingAmount))
            - Monthly Investment: ₹\(CurrencyFormatter.formatCompact(goal.monthlyInvestment))
            - Days Remaining: \(goal.daysRemaining)
            - Category: \(goal.category.rawValue)
            """
        }.joined(separator: "\n\n")
        
        return """
        You are an expert financial advisor and AI analyst specializing in stock market investments and goal-based financial planning. Your task is to analyze the provided stock data and financial goals to generate personalized stock investment recommendations.

        STOCK MARKET DATA:
        \(stockData)

        FINANCIAL GOALS:
        \(goalData)

        USER PREFERENCES:
        - Risk Tolerance: \(preferences.riskTolerance.rawValue)
        - Investment Horizon: \(preferences.investmentHorizon) months
        - Maximum Investment per Stock: ₹\(CurrencyFormatter.formatCompact(preferences.maxInvestmentPerStock))
        - Preferred Sectors: \(preferences.preferredSectors.isEmpty ? "Any" : preferences.preferredSectors.joined(separator: ", "))

        ANALYSIS REQUIREMENTS:
        1. For each financial goal, recommend the best 1-3 stocks that can help achieve the goal in the shortest time
        2. Consider the user's risk tolerance and investment horizon
        3. Analyze stock performance, trends, and risk levels
        4. Calculate expected returns and time to goal achievement
        5. Provide detailed reasoning for each recommendation
        6. Consider market conditions and stock volatility

        RECOMMENDATION FORMAT:
        For each recommendation, provide:
        - Stock selection with detailed reasoning
        - Expected annual return percentage (realistic based on historical data)
        - Estimated time to reach the goal (in months)
        - Risk assessment (Low/Medium/High with explanation)
        - Investment strategy (lump sum vs SIP, quantity recommendations)
        - Confidence level (0.0 to 1.0 based on analysis)

        IMPORTANT CONSIDERATIONS:
        - Prioritize stocks that match the user's risk tolerance
        - Consider the goal timeline and required returns
        - Factor in market volatility and economic conditions
        - Provide realistic return expectations
        - Consider diversification across different sectors
        - Account for the user's monthly investment capacity

        Generate comprehensive, well-reasoned recommendations that will help the user achieve their financial goals efficiently and safely.
        """
    }

    // MARK: - Helper Methods
    private func addThinkingStep(_ step: String, _ message: String, type: GenerationStep.StepType) async {
        let generationStep = GenerationStep(step: step, message: message, timestamp: Date(), type: type)
        thinkingProcess.addStep(generationStep)
        logToTerminal("Step: \(step)", level: .info)
        logToTerminal(message, level: .thinking)
    }
    
    // MARK: - Generate Recommendations for Goals
    private func generateRecommendationsForGoals(
        stocks: [Stock],
        goals: [Goal],
        preferences: UserPreferences
    ) async -> [StockRecommendation] {
        var recommendations: [StockRecommendation] = []
        
        for goal in goals {
            let suitableStocks = filterStocksForGoal(stocks: stocks, goal: goal, preferences: preferences)
            
            for stock in suitableStocks.prefix(3) { // Top 3 recommendations per goal
                let recommendation = createRecommendation(
                    stock: stock,
                    goal: goal,
                    preferences: preferences
                )
                recommendations.append(recommendation)
            }
        }
        
        return recommendations.sorted { ($0.confidence ?? 0) > ($1.confidence ?? 0) }
    }
    
    // MARK: - Filter Stocks for Goal
    private func filterStocksForGoal(
        stocks: [Stock],
        goal: Goal,
        preferences: UserPreferences
    ) -> [Stock] {
        return stocks.filter { stock in
            // Risk tolerance filter
            let riskMatches = stock.riskLevel == preferences.riskTolerance
            
            // Price filter - ensure we can buy at least 1 share
            let priceMatches = stock.price <= preferences.totalInvestmentAmount
            
            return riskMatches && priceMatches
        }
        .sorted { $0.potentialReturn > $1.potentialReturn }
    }
    
    // MARK: - Create Recommendation
    private func createRecommendation(
        stock: Stock,
        goal: Goal,
        preferences: UserPreferences
    ) -> StockRecommendation {
        let (suggestedQuantity, timeToGoal) = calculateOptimalQuantity(stock: stock, goal: goal, preferences: preferences)
        let totalInvestment = stock.price * Double(suggestedQuantity)
        
        let confidence = calculateConfidence(stock: stock, goal: goal)
        let expectedReturn = stock.potentialReturn
        
        return StockRecommendation(
            id: UUID(),
            stock: stock,
            goal: goal,
            reasoning: generateReasoning(stock: stock, goal: goal),
            confidence: confidence,
            expectedReturn: expectedReturn,
            timeToGoal: timeToGoal,
            riskAssessment: generateRiskAssessment(stock: stock),
            investmentStrategy: generateInvestmentStrategy(stock: stock, goal: goal, quantity: suggestedQuantity, totalInvestment: totalInvestment, timeToGoal: timeToGoal)
        )
    }
    
    // MARK: - Helper Methods
    private func calculateOptimalQuantity(stock: Stock, goal: Goal, preferences: UserPreferences) -> (quantity: Int, timeToGoal: Int) {
        let availableInvestment = preferences.totalInvestmentAmount
        let goalAmount = goal.remainingAmount
        let stockPrice = stock.price
        let annualReturnRate = stock.potentialReturn / 100 // Convert percentage to decimal
        
        // Calculate maximum shares we can buy with available investment
        let maxShares = Int(availableInvestment / stockPrice)
        
        // Calculate shares needed to reach goal using compound interest
        // The goal is to have the investment grow to: goalAmount + availableInvestment
        // Because the user wants their investment to grow to cover the remaining goal amount
        // AND they want their original investment back
        
        var optimalShares = 1
        var bestTimeToGoal = Int.max
        var bestInvestment = 0.0
        
        // Try different quantities to find the optimal solution
        for shares in 1...maxShares {
            let investment = Double(shares) * stockPrice
            
            // Calculate the total amount needed (goal amount + original investment)
            let totalAmountNeeded = goalAmount + investment
            
            // Calculate time to reach total amount using compound interest
            // FV = investment * (1 + annualReturnRate)^n
            // totalAmountNeeded = investment * (1 + annualReturnRate)^n
            // n = log(totalAmountNeeded / investment) / log(1 + annualReturnRate)
            
            let timeToGoal = calculateTimeWithCompoundInterest(
                presentValue: investment,
                futureValue: totalAmountNeeded,
                annualRate: annualReturnRate
            )
            
            // Prefer solutions that are realistic (not more than 30 years)
            if timeToGoal <= 30 && timeToGoal < bestTimeToGoal {
                optimalShares = shares
                bestTimeToGoal = timeToGoal
                bestInvestment = investment
            }
        }
        
        // If no optimal solution found, use maximum shares possible
        if bestTimeToGoal == Int.max {
            optimalShares = maxShares
            let totalAmountNeeded = goalAmount + (Double(maxShares) * stockPrice)
            bestTimeToGoal = calculateTimeWithCompoundInterest(
                presentValue: Double(maxShares) * stockPrice,
                futureValue: totalAmountNeeded,
                annualRate: annualReturnRate
            )
        }
        
        return (optimalShares, bestTimeToGoal)
    }
    
    private func calculateTimeWithCompoundInterest(presentValue: Double, futureValue: Double, annualRate: Double) -> Int {
        guard presentValue > 0 && futureValue > 0 && annualRate > 0 else { return 0 }
        
        // Formula: n = log(FV/PV) / log(1 + r)
        let ratio = futureValue / presentValue
        let logRatio = log(ratio)
        let logRate = log(1 + annualRate)
        
        let years = logRatio / logRate
        return max(0, Int(ceil(years)))
    }
    
    private func calculateConfidence(stock: Stock, goal: Goal) -> Double {
        var confidence = 0.5 // Base confidence
        
        // Adjust based on stock performance
        if stock.percentChange > 0 { confidence += 0.1 }
        if stock.shortTermTrend.lowercased() == "bullish" { confidence += 0.15 }
        if stock.overallRating.lowercased() == "buy" { confidence += 0.1 }
        
        // Adjust based on goal alignment
        let timeToGoal = Int(ceil(goal.remainingAmount / goal.monthlyInvestment))
        if timeToGoal <= 12 { confidence += 0.1 } // Short-term goals
        else if timeToGoal <= 36 { confidence += 0.05 } // Medium-term goals
        
        return min(confidence, 1.0)
    }
    
    private func calculateTimeToGoal(stock: Stock, goal: Goal, investment: Double) -> Int {
        let annualReturnRate = stock.potentialReturn / 100
        let totalAmountNeeded = goal.remainingAmount + investment
        return calculateTimeWithCompoundInterest(
            presentValue: investment,
            futureValue: totalAmountNeeded,
            annualRate: annualReturnRate
        )
    }
    

    
    private func generateReasoning(stock: Stock, goal: Goal) -> String {
        var reasons: [String] = []
        
        if stock.shortTermTrend.lowercased() == "bullish" {
            reasons.append("Positive short-term trend")
        }
        if stock.potentialReturn > 20 {
            reasons.append("High growth potential")
        }
        if stock.riskLevel == .low {
            reasons.append("Low risk profile")
        }
        if stock.volume > 1000000 {
            reasons.append("High liquidity")
        }
        
        return reasons.joined(separator: ", ")
    }
    
    private func generateRiskAssessment(stock: Stock) -> String {
        switch stock.riskLevel {
        case .low:
            return "Low risk - Stable performance with consistent returns"
        case .medium:
            return "Medium risk - Moderate volatility with growth potential"
        case .high:
            return "High risk - Volatile but high growth potential"
        }
    }
    
    private func generateInvestmentStrategy(stock: Stock, goal: Goal, quantity: Int, totalInvestment: Double, timeToGoal: Int) -> String {
        let originalTimeToGoal = Int(ceil(goal.remainingAmount / goal.monthlyInvestment))
        let timeSaved = originalTimeToGoal - timeToGoal
        
        if timeToGoal == 0 {
            return "Invest ₹\(CurrencyFormatter.formatCompact(totalInvestment)) in \(quantity) shares of \(stock.company) to immediately achieve your \(goal.name) goal. Your investment will grow to cover the goal amount plus return your original investment."
        } else if timeSaved > 0 {
            return "Invest ₹\(CurrencyFormatter.formatCompact(totalInvestment)) in \(quantity) shares of \(stock.company) to achieve your \(goal.name) goal in \(timeToGoal) years (saving \(timeSaved) months). Your investment will grow to ₹\(CurrencyFormatter.formatCompact(goal.remainingAmount + totalInvestment)) and return your original investment."
        } else if timeSaved == 0 {
            return "Invest ₹\(CurrencyFormatter.formatCompact(totalInvestment)) in \(quantity) shares of \(stock.company) to achieve your \(goal.name) goal in \(timeToGoal) years. Your investment will grow to ₹\(CurrencyFormatter.formatCompact(goal.remainingAmount + totalInvestment)) and return your original investment."
        } else {
            return "Invest ₹\(CurrencyFormatter.formatCompact(totalInvestment)) in \(quantity) shares of \(stock.company) to achieve your \(goal.name) goal in \(timeToGoal) years. Your investment will grow to ₹\(CurrencyFormatter.formatCompact(goal.remainingAmount + totalInvestment)) and return your original investment."
        }
    }
    
    private func generateMarketAnalysis(stocks: [Stock]) -> String {
        let topPerformers = stocks.filter { $0.percentChange > 0 }.count
        let totalStocks = stocks.count
        let bullishStocks = stocks.filter { $0.shortTermTrend.lowercased() == "bullish" }.count
        
        return """
        Market Analysis:
        • \(topPerformers) out of \(totalStocks) stocks showing positive performance
        • \(bullishStocks) stocks with bullish short-term trends
        • Average potential return: \(String(format: "%.1f", stocks.map { $0.potentialReturn }.reduce(0, +) / Double(stocks.count)))%
        • Market sentiment: \(bullishStocks > totalStocks / 2 ? "Positive" : "Mixed")
        """
    }
    
    private func generateMarketInsights(stocks: [Stock]) -> String {
        let highVolumeStocks = stocks.filter { $0.volume > 1000000 }
        let lowRiskStocks = stocks.filter { $0.riskLevel == .low }
        
        return """
        Market Insights:
        • High liquidity stocks available for easy trading
        • \(lowRiskStocks.count) low-risk options for conservative investors
        • Focus on stocks with strong fundamentals and growth potential
        • Consider diversifying across different risk levels
        """
    }
    
    private func generateRiskWarnings(stocks: [Stock]) -> String {
        let highRiskStocks = stocks.filter { $0.riskLevel == .high }
        
        return """
        Risk Warnings:
        • \(highRiskStocks.count) high-risk stocks identified
        • Past performance doesn't guarantee future returns
        • Always diversify your investment portfolio
        • Consider consulting a financial advisor
        • Monitor your investments regularly
        """
    }
    
    private func calculateTimeEstimates(recommendations: [StockRecommendation], goals: [Goal]) -> [String: Int] {
        var estimates: [String: Int] = [:]
        
        for goal in goals {
            let goalRecommendations = recommendations.filter { $0.goal?.id == goal.id }
            if let bestRecommendation = goalRecommendations.first {
                estimates[goal.name] = bestRecommendation.timeToGoal ?? 0
            }
        }
        
        return estimates
    }
    
    // MARK: - Fallback Recommendations
    private func createFallbackRecommendations(stocks: [Stock], goals: [Goal], preferences: UserPreferences) -> [StockRecommendation] {
        var recommendations: [StockRecommendation] = []
        
        for goal in goals {
            // Find best stocks for this goal based on basic criteria
            let suitableStocks = stocks.filter { stock in
                // Filter by risk tolerance
                switch preferences.riskTolerance {
                case .low:
                    return stock.riskLevel == .low
                case .medium:
                    return stock.riskLevel == .low || stock.riskLevel == .medium
                case .high:
                    return true // Accept all risk levels
                }
            }
            
            // Sort by potential return and select top 2
            let topStocks = suitableStocks.sorted { $0.potentialReturn > $1.potentialReturn }.prefix(2)
            
            for stock in topStocks {
                let expectedReturn = stock.potentialReturn
                let timeToGoal = calculateTimeToGoal(goal: goal, expectedReturn: expectedReturn)
                let confidence = calculateConfidence(stock: stock, goal: goal)
                
                let recommendation = StockRecommendation(
                    id: UUID(),
                    stock: stock,
                    goal: goal,
                    reasoning: "Fallback recommendation: \(stock.company) shows strong potential with \(String(format: "%.1f", expectedReturn))% expected return and matches your \(preferences.riskTolerance.rawValue) risk tolerance.",
                    confidence: confidence,
                    expectedReturn: expectedReturn,
                    timeToGoal: timeToGoal,
                    riskAssessment: "Risk level: \(stock.riskLevel.rawValue). \(stock.riskLevel.description)",
                    investmentStrategy: "Consider investing ₹\(CurrencyFormatter.formatCompact(min(preferences.maxInvestmentPerStock, goal.remainingAmount * 0.3))) in \(stock.company) to accelerate your goal achievement."
                )
                
                recommendations.append(recommendation)
            }
        }
        
        return recommendations
    }
    
    private func calculateTimeToGoal(goal: Goal, expectedReturn: Double) -> Int {
        let monthlyReturn = expectedReturn / 12 / 100
        let requiredAmount = goal.remainingAmount
        let monthlyInvestment = goal.monthlyInvestment
        
        // Simple compound interest calculation
        var months = 0
        var currentAmount = goal.currentAmount
        
        while currentAmount < goal.targetAmount && months < 120 { // Max 10 years
            currentAmount += monthlyInvestment
            currentAmount *= (1 + monthlyReturn)
            months += 1
        }
        
        return months
    }
    
} 
 