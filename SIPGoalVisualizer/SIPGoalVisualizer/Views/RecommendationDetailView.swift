//
//  RecommendationDetailView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/28/25.
//

import SwiftUI

struct RecommendationDetailView: View {
    let recommendation: StockRecommendation
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingInvestmentSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with confidence
                    RecommendationHeaderView(recommendation: recommendation)
                    
                    // Stock details
                    StockDetailsCard(recommendation: recommendation)
                    
                    // Goal impact analysis
                    GoalImpactCard(recommendation: recommendation)
                    
                    // AI reasoning
                    AIReasoningCard(recommendation: recommendation)
                    
                    // Risk assessment
                    RiskAssessmentCard(recommendation: recommendation)
                    
                    // Investment action
                    InvestmentActionCard(
                        recommendation: recommendation,
                        onInvest: {
                            showingInvestmentSheet = true
                        }
                    )
                }
                .padding()
            }
            .navigationTitle("AI Recommendation")
            .navigationBarTitleDisplayMode(.large)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingInvestmentSheet) {
                if let stock = recommendation.stock, let goal = recommendation.goal {
                    let suggestedQuantity = Int(goal.remainingAmount * 0.3 / stock.price)
                    InvestmentConfirmationView(
                        stock: stock,
                        quantity: suggestedQuantity,
                        goal: goal
                    )
                    .environmentObject(viewModel)
                }
            }
        }
    }
}

struct RecommendationHeaderView: View {
    let recommendation: StockRecommendation
    
    var body: some View {
        VStack(spacing: 15) {
            // Confidence indicator
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: recommendation.confidence ?? 0)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [recommendation.confidenceColor, recommendation.confidenceColor.opacity(0.5)]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text("\(Int((recommendation.confidence ?? 0) * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(recommendation.confidenceColor)
                    
                    Text("Confidence")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 8) {
                Text(recommendation.displayInvestmentStrategy)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(recommendation.confidenceText)
                    .font(.subheadline)
                    .foregroundColor(recommendation.confidenceColor)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct StockDetailsCard: View {
    let recommendation: StockRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Stock Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            if let stock = recommendation.stock {
                VStack(spacing: 12) {
                    DetailRow(title: "Company", value: stock.company)
                    DetailRow(title: "Ticker", value: stock.ticker)
                    DetailRow(title: "Current Price", value: "₹\(String(format: "%.2f", stock.price))")
                    DetailRow(title: "Price Change", value: "\(String(format: "%.2f", stock.percentChange))%", color: stock.priceColor)
                    DetailRow(title: "Volume", value: "\(stock.volume.formatted())")
                    DetailRow(title: "52-Week High", value: "₹\(String(format: "%.2f", stock.week52High))", color: .green)
                    DetailRow(title: "52-Week Low", value: "₹\(String(format: "%.2f", stock.week52Low))", color: .red)
                }
            } else {
                Text("Stock information not available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct GoalImpactCard: View {
    let recommendation: StockRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Goal Impact Analysis")
                .font(.headline)
                .fontWeight(.semibold)
            
            if let goal = recommendation.goal {
                VStack(spacing: 12) {
                    DetailRow(title: "Goal", value: goal.name)
                    DetailRow(title: "Current Progress", value: "\(Int(goal.progress * 100))%")
                    DetailRow(title: "Remaining Amount", value: "₹\(String(format: "%.2f", goal.remainingAmount))")
                    DetailRow(title: "Monthly Investment", value: "₹\(String(format: "%.2f", goal.monthlyInvestment))")
                    
                    Divider()
                    
                    let totalInvestment = recommendation.displayExpectedReturn > 0 ? (goal.remainingAmount * 0.3) : 0
                    DetailRow(title: "Suggested Investment", value: "₹\(String(format: "%.2f", totalInvestment))", color: .blue, isHighlighted: true)
                    DetailRow(title: "Expected Return", value: "₹\(String(format: "%.2f", totalInvestment * recommendation.displayExpectedReturn / 100))", color: .green)
                    DetailRow(title: "Time to Goal", value: "\(recommendation.displayTimeToGoal) months", color: .purple)
                    
                    let originalTime = Int(ceil(goal.remainingAmount / goal.monthlyInvestment))
                    let timeSaved = originalTime - recommendation.displayTimeToGoal
                    if timeSaved > 0 {
                        DetailRow(title: "Time Saved", value: "\(timeSaved) months", color: .green, isHighlighted: true)
                    }
                }
            } else {
                Text("Goal information not available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct AIReasoningCard: View {
    let recommendation: StockRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.blue)
                Text("AI Reasoning")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(recommendation.displayReasoning)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                // Key factors
                if let stock = recommendation.stock {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Key Factors:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            ReasoningFactor(
                                factor: "Market Trend",
                                value: stock.shortTermTrend,
                                color: getTrendColor(stock.shortTermTrend)
                            )
                            
                            ReasoningFactor(
                                factor: "Overall Rating",
                                value: stock.overallRating,
                                color: getRatingColor(stock.overallRating)
                            )
                            
                            ReasoningFactor(
                                factor: "Risk Level",
                                value: stock.riskLevel.rawValue,
                                color: stock.riskLevel.color
                            )
                            
                            ReasoningFactor(
                                factor: "Potential Return",
                                value: "\(String(format: "%.1f", stock.potentialReturn))%",
                                color: .green
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private func getTrendColor(_ trend: String) -> Color {
        switch trend.lowercased() {
        case "bullish": return .green
        case "bearish": return .red
        default: return .orange
        }
    }
    
    private func getRatingColor(_ rating: String) -> Color {
        switch rating.lowercased() {
        case "buy": return .green
        case "sell": return .red
        case "hold": return .orange
        default: return .secondary
        }
    }
}



struct RiskAssessmentCard: View {
    let recommendation: StockRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                Text("Risk Assessment")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            if let stock = recommendation.stock {
                VStack(spacing: 12) {
                    DetailRow(title: "Risk Level", value: stock.riskLevel.rawValue, color: stock.riskLevel.color)
                    DetailRow(title: "Volatility", value: "\(String(format: "%.1f", abs(stock.percentChange)))%", color: abs(stock.percentChange) > 5 ? .red : .orange)
                    DetailRow(title: "Liquidity", value: stock.volume > 1000000 ? "High" : "Moderate", color: stock.volume > 1000000 ? .green : .orange)
                    
                    Text(recommendation.displayRiskAssessment)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                }
            } else {
                Text("Risk assessment information not available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct InvestmentActionCard: View {
    let recommendation: StockRecommendation
    let onInvest: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Ready to Invest?")
                .font(.headline)
                .fontWeight(.semibold)
            
            if let stock = recommendation.stock, let goal = recommendation.goal {
                VStack(spacing: 8) {
                    let suggestedQuantity = Int(goal.remainingAmount * 0.3 / stock.price)
                    let totalInvestment = Double(suggestedQuantity) * stock.price
                    
                    DetailRow(title: "Suggested Quantity", value: "\(suggestedQuantity) shares")
                    DetailRow(title: "Total Investment", value: "₹\(String(format: "%.2f", totalInvestment))", isHighlighted: true)
                    DetailRow(title: "Expected Return", value: "₹\(String(format: "%.2f", totalInvestment * recommendation.displayExpectedReturn / 100))", color: .green)
                }
                
                Button(action: onInvest) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Invest in \(stock.company)")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
            } else {
                Text("Investment information not available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

 