//
//  Stock.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import Foundation
import SwiftUI

// MARK: - Stock Models
struct Stock: Identifiable, Codable {
    let id = UUID()
    let ticker: String
    let company: String
    let price: Double
    let percentChange: Double
    let netChange: Double
    let bid: Double
    let ask: Double
    let high: Double
    let low: Double
    let open: Double
    let lowCircuitLimit: Double
    let upCircuitLimit: Double
    let volume: Int
    let close: Double
    let overallRating: String
    let shortTermTrend: String
    let longTermTrend: String
    let week52Low: Double
    let week52High: Double
    
    // Computed properties
    var isPositive: Bool {
        percentChange >= 0
    }
    
    var priceColor: Color {
        isPositive ? .green : .red
    }
    
    var trendColor: Color {
        switch shortTermTrend.lowercased() {
        case "bullish": return .green
        case "bearish": return .red
        default: return .orange
        }
    }
    
    var riskLevel: RiskLevel {
        let volatility = abs(percentChange)
        switch volatility {
        case 0..<2: return .low
        case 2..<5: return .medium
        default: return .high
        }
    }
    
    var potentialReturn: Double {
        // Calculate potential return based on current price vs 52-week high
        let potential = (week52High - price) / price * 100
        return min(potential, 50) // Cap at 50% for realistic expectations
    }
    
    enum CodingKeys: String, CodingKey {
        case ticker, company, price, percentChange = "percent_change", netChange = "net_change"
        case bid, ask, high, low, open, lowCircuitLimit = "low_circuit_limit"
        case upCircuitLimit = "up_circuit_limit", volume, close, overallRating = "overall_rating"
        case shortTermTrend = "short_term_trend", longTermTrend = "long_term_trend"
        case week52Low = "52_week_low", week52High = "52_week_high"
    }
}

enum RiskLevel: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Stable, low volatility"
        case .medium: return "Moderate risk and return"
        case .high: return "High volatility, high potential"
        }
    }
}

// MARK: - Stock Investment Models
struct StockInvestment: Identifiable, Codable {
    let id = UUID()
    let stock: Stock
    let quantity: Int
    let investmentAmount: Double
    let goalId: UUID
    let dateAdded: Date
    
    var totalValue: Double {
        stock.price * Double(quantity)
    }
    
    var profitLoss: Double {
        totalValue - investmentAmount
    }
    
    var profitLossPercentage: Double {
        (profitLoss / investmentAmount) * 100
    }
   
   
}

// MARK: - Stock Recommendation Models
struct StockRecommendation: Identifiable, Codable {
    let id: UUID?
    let stock: Stock?
    let goal: Goal?
    let reasoning: String?
    let confidence: Double?
    let expectedReturn: Double?
    let timeToGoal: Int?
    let riskAssessment: String?
    let investmentStrategy: String?
    
    // Computed properties for UI
    var confidenceColor: Color {
        guard let confidence = confidence else { return .gray }
        switch confidence {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .orange
        default: return .red
        }
    }
    
    var confidenceText: String {
        guard let confidence = confidence else { return "Unknown" }
        switch confidence {
        case 0.8...1.0: return "High Confidence"
        case 0.6..<0.8: return "Medium Confidence"
        default: return "Low Confidence"
        }
    }
    
    var displayName: String {
        stock?.company ?? "Unknown Stock"
    }
    
    var displayGoal: String {
        goal?.name ?? "Unknown Goal"
    }
    
    var displayReasoning: String {
        reasoning ?? "No reasoning provided"
    }
    
    var displayExpectedReturn: Double {
        expectedReturn ?? 0.0
    }
    
    var displayTimeToGoal: Int {
        timeToGoal ?? 0
    }
    
    var displayTimeToGoalText: String {
        let time = timeToGoal ?? 0
        if time == 0 {
            return "Immediate"
        } else if time == 1 {
            return "1 year"
        } else {
            return "\(time) years"
        }
    }
    
    var displayRiskAssessment: String {
        riskAssessment ?? "Risk assessment not available"
    }
    
    var displayInvestmentStrategy: String {
        investmentStrategy ?? "Investment strategy not available"
    }
}

// MARK: - Stock Comparison Models
struct StockComparison {
    let stock1: StockRecommendation
    let stock2: StockRecommendation
    let comparison: String
    let winner: StockRecommendation
    let advantages: [String]
    let disadvantages: [String]
}

// MARK: - LLM Response Models
struct LLMStockAnalysis {
    let recommendations: [StockRecommendation]
    let analysis: String
    let marketInsights: String
    let riskWarnings: String
    let timeEstimates: [String: Int] // Goal name to months
}

struct LLMRequest {
    let stocks: [Stock]
    let goals: [Goal]
    let userPreferences: UserPreferences
}

struct UserPreferences {
    let riskTolerance: RiskLevel
    let investmentHorizon: Int // months
    let preferredSectors: [String]
    let maxInvestmentPerStock: Double
    let totalInvestmentAmount: Double
} 
