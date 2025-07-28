//
//  GoalsViewModel.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import Foundation
import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var selectedGoal: Goal?
    @Published var showingAddGoal = false
    @Published var showingGoalDetail = false
    
    // Stock-related properties
    @Published var stockInvestments: [StockInvestment] = []
    @Published var stockRecommendations: [StockRecommendation] = []
    @Published var showingStockRecommendations = false
    @Published var showingStockComparison = false
    @Published var selectedStocksForComparison: [StockRecommendation] = []
    @Published var stockCount: Int = 0
    @Published var isStockLoading: Bool = false
    
    // Services
    let stockService = StockService()
    let llmService = LLMService()
    private var cancellables = Set<AnyCancellable>()
    
    // User preferences
    @Published var userPreferences = UserPreferences(
        riskTolerance: .medium,
        investmentHorizon: 24,
        preferredSectors: [],
        maxInvestmentPerStock: 100000,
        totalInvestmentAmount: 100000
    )
    
    init() {
        loadSampleData()
        setupStockService()
    }
    
    // MARK: - Stock Service Setup
    private func setupStockService() {
        // Observe stock service updates
        stockService.$stocks
            .sink { [weak self] stocks in
                self?.handleStocksUpdate(stocks)
            }
            .store(in: &cancellables)
        
        stockService.$isLoading
            .sink { [weak self] isLoading in
                DispatchQueue.main.async {
                    self?.isStockLoading = isLoading
                }
            }
            .store(in: &cancellables)
        
        stockService.$errorMessage
            .sink { [weak self] error in
                if let error = error {
                    print("Stock service error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleStocksUpdate(_ stocks: [Stock]) {
        // Handle stock data updates
        print("Received \(stocks.count) stocks from API")
        DispatchQueue.main.async {
            self.stockCount = stocks.count
        }
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveGoals()
    }
    
    func addInvestment(to goal: Goal, amount: Double) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].currentAmount += amount
            
            // Check if goal is completed
            if goals[index].currentAmount >= goals[index].targetAmount {
                goals[index].isCompleted = true
            }
            
            saveGoals()
        }
    }
    
    private func saveGoals() {
        // In a real app, you'd save to UserDefaults or Core Data
        // For now, we'll just keep it in memory
    }
    
    func loadSampleData() {
        let sampleGoals = [
            Goal(
                name: "Dream Bike",
                targetAmount: 150000,
                currentAmount: 45000,
                monthlyInvestment: 5000,
                startDate: Date().addingTimeInterval(-90 * 24 * 60 * 60),
                targetDate: Date().addingTimeInterval(120 * 24 * 60 * 60),
                category: .vehicle
            ),
            Goal(
                name: "Europe Trip",
                targetAmount: 300000,
                currentAmount: 75000,
                monthlyInvestment: 8000,
                startDate: Date().addingTimeInterval(-60 * 24 * 60 * 60),
                targetDate: Date().addingTimeInterval(180 * 24 * 60 * 60),
                category: .travel
            ),
            Goal(
                name: "MacBook Pro",
                targetAmount: 120000,
                currentAmount: 90000,
                monthlyInvestment: 3000,
                startDate: Date().addingTimeInterval(-120 * 24 * 60 * 60),
                targetDate: Date().addingTimeInterval(30 * 24 * 60 * 60),
                category: .gadget
            )
        ]
        
        goals = sampleGoals
    }
    
    func calculateRequiredMonthlyInvestment(targetAmount: Double, currentAmount: Double, monthsRemaining: Double) -> Double {
        let remainingAmount = targetAmount - currentAmount
        return remainingAmount / monthsRemaining
    }
    
    func getTotalInvested() -> Double {
        return goals.reduce(0) { $0 + $1.currentAmount }
    }
    
    func getTotalTarget() -> Double {
        return goals.reduce(0) { $0 + $1.targetAmount }
    }
    
    func getOverallProgress() -> Double {
        let totalInvested = getTotalInvested()
        let totalTarget = getTotalTarget()
        return totalTarget > 0 ? totalInvested / totalTarget : 0
    }
    
    // MARK: - Stock Management
    func fetchStocks() {
        stockService.fetchMostActiveStocks()
    }
    
    func refreshStocks() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        stockService.refreshStocks()
    }
    
    // MARK: - Testing Different Auth Methods
    func testWithoutAuth() {
        stockService.fetchMostActiveStocksWithoutAuth()
    }
    
    func testWithHeaderAuth() {
        stockService.fetchMostActiveStocksWithHeaderAuth()
    }
    
    func getStocks() -> [Stock] {
        return stockService.stocks
    }
    
    func addStockInvestment(stock: Stock, quantity: Int, goalId: UUID) {
        let investment = StockInvestment(
            stock: stock,
            quantity: quantity,
            investmentAmount: stock.price * Double(quantity),
            goalId: goalId,
            dateAdded: Date()
        )
        
        stockInvestments.append(investment)
        
        // Update goal with stock investment
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            goals[index].currentAmount += investment.investmentAmount
        }
    }
    
    func getStockInvestments(for goalId: UUID) -> [StockInvestment] {
        return stockInvestments.filter { $0.goalId == goalId }
    }
    
    func getTotalStockValue() -> Double {
        return stockInvestments.reduce(0) { $0 + $1.totalValue }
    }
    
    func getTotalStockProfitLoss() -> Double {
        return stockInvestments.reduce(0) { $0 + $1.profitLoss }
    }
    
    // MARK: - LLM Stock Recommendations
    func generateStockRecommendations(preferences: UserPreferences? = nil) async {
        guard !goals.isEmpty && !stockService.stocks.isEmpty else {
            print("No goals or stocks available for recommendations")
            return
        }
        
        let userPrefs = preferences ?? UserPreferences(
            riskTolerance: .medium,
            investmentHorizon: 60, // Default to 5 years
            preferredSectors: [],
            maxInvestmentPerStock: 100000, // Use total amount as max per stock
            totalInvestmentAmount: 100000
        )
        
        do {
            let analysis = try await llmService.generateStockRecommendations(
                stocks: stockService.stocks,
                goals: goals,
                userPreferences: userPrefs
            )
            
            await MainActor.run {
                self.stockRecommendations = analysis.recommendations
                self.showingStockRecommendations = true
                
                // Add success haptic feedback
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
            }
        } catch {
            print("Error generating stock recommendations: \(error)")
            
            await MainActor.run {
                // Add error haptic feedback
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.error)
            }
        }
    }
    
    func getRecommendationsForGoal(_ goalId: UUID) -> [StockRecommendation] {
        return stockRecommendations.filter { $0.goal?.id == goalId }
    }
    
    func selectStockForComparison(_ recommendation: StockRecommendation) {
        if selectedStocksForComparison.contains(where: { $0.id == recommendation.id }) {
            selectedStocksForComparison.removeAll { $0.id == recommendation.id }
        } else {
            selectedStocksForComparison.append(recommendation)
        }
        
        if selectedStocksForComparison.count == 2 {
            showingStockComparison = true
        }
    }
    
    func compareStocks() -> StockComparison? {
        guard selectedStocksForComparison.count == 2 else { return nil }
        
        let stock1 = selectedStocksForComparison[0]
        let stock2 = selectedStocksForComparison[1]
        
        let confidence1 = stock1.confidence ?? 0
        let confidence2 = stock2.confidence ?? 0
        let winner = confidence1 > confidence2 ? stock1 : stock2
        
        let advantages = generateComparisonAdvantages(stock1: stock1, stock2: stock2)
        let disadvantages = generateComparisonDisadvantages(stock1: stock1, stock2: stock2)
        
        return StockComparison(
            stock1: stock1,
            stock2: stock2,
            comparison: generateComparisonText(stock1: stock1, stock2: stock2),
            winner: winner,
            advantages: advantages,
            disadvantages: disadvantages
        )
    }
    
    private func generateComparisonText(stock1: StockRecommendation, stock2: StockRecommendation) -> String {
        let confidence1 = stock1.confidence ?? 0
        let confidence2 = stock2.confidence ?? 0
        
        if confidence1 > confidence2 {
            return "\(stock1.displayName) has higher confidence (\(Int(confidence1 * 100))% vs \(Int(confidence2 * 100))%)"
        } else {
            return "\(stock2.displayName) has higher confidence (\(Int(confidence2 * 100))% vs \(Int(confidence1 * 100))%)"
        }
    }
    
    private func generateComparisonAdvantages(stock1: StockRecommendation, stock2: StockRecommendation) -> [String] {
        var advantages: [String] = []
        
        let return1 = stock1.expectedReturn ?? 0
        let return2 = stock2.expectedReturn ?? 0
        let time1 = stock1.timeToGoal ?? 0
        let time2 = stock2.timeToGoal ?? 0
        
        if return1 > return2 {
            advantages.append("\(stock1.displayName) has higher expected return")
        }
        if time1 < time2 {
            advantages.append("\(stock1.displayName) reaches goal faster")
        }
        
        // Compare risk levels safely
        if let stock1Data = stock1.stock, let stock2Data = stock2.stock {
            if stock1Data.riskLevel.rawValue < stock2Data.riskLevel.rawValue {
                advantages.append("\(stock1.displayName) has lower risk")
            }
        }
        
        return advantages
    }
    
    private func generateComparisonDisadvantages(stock1: StockRecommendation, stock2: StockRecommendation) -> [String] {
        var disadvantages: [String] = []
        
        let return1 = stock1.expectedReturn ?? 0
        let return2 = stock2.expectedReturn ?? 0
        let time1 = stock1.timeToGoal ?? 0
        let time2 = stock2.timeToGoal ?? 0
        
        if return1 < return2 {
            disadvantages.append("\(stock1.displayName) has lower expected return")
        }
        if time1 > time2 {
            disadvantages.append("\(stock1.displayName) takes longer to reach goal")
        }
        
        // Compare risk levels safely
        if let stock1Data = stock1.stock, let stock2Data = stock2.stock {
            if stock1Data.riskLevel.rawValue > stock2Data.riskLevel.rawValue {
                disadvantages.append("\(stock1.displayName) has higher risk")
            }
        }
        
        return disadvantages
    }
} 
 