//
//  InvestmentConfirmationView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/29/25.
//

import SwiftUI

struct InvestmentConfirmationView: View {
    let stock: Stock
    let quantity: Int
    let goal: Goal
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingSuccess = false
    
    var totalInvestment: Double {
        stock.price * Double(quantity)
    }
    
    var expectedReturn: Double {
        totalInvestment * stock.potentialReturn / 100
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if showingSuccess {
                    SuccessView()
                } else {
                    ConfirmationView()
                }
            }
            .navigationTitle("Investment Details")
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
        }
    }
    
    @ViewBuilder
    private func ConfirmationView() -> some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    
                    Text("Review Investment")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Review your investment details before confirming")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Investment details
                VStack(spacing: 15) {
                    InvestmentDetailCard()
                    
                    GoalImpactCard()
                    
                    RiskSummaryCard()
                }
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        confirmInvestment()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Confirm Investment")
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
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func SuccessView() -> some View {
        VStack(spacing: 30) {
            // Success animation
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(showingSuccess ? 1.0 : 0.5)
            .animation(AnimationUtils.springAnimation, value: showingSuccess)
            
            VStack(spacing: 15) {
                Text("Investment Successful!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("Your investment in \(stock.company) has been added to your \(goal.name) goal")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Investment summary
            VStack(spacing: 12) {
                SummaryRow(title: "Stock", value: stock.company)
                SummaryRow(title: "Quantity", value: "\(quantity) shares")
                SummaryRow(title: "Investment", value: "₹\(String(format: "%.2f", totalInvestment))")
                SummaryRow(title: "Expected Return", value: "₹\(String(format: "%.2f", expectedReturn))", color: .green)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            
            Button(action: {
                dismiss()
            }) {
                Text("Done")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                    )
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func InvestmentDetailCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Investment Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                DetailRow(title: "Company", value: stock.company)
                DetailRow(title: "Ticker", value: stock.ticker)
                DetailRow(title: "Current Price", value: "₹\(String(format: "%.2f", stock.price))")
                DetailRow(title: "Quantity", value: "\(quantity) shares")
                DetailRow(title: "Total Investment", value: "₹\(String(format: "%.2f", totalInvestment))", isHighlighted: true)
                DetailRow(title: "Expected Return", value: "₹\(String(format: "%.2f", expectedReturn))", color: .green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    @ViewBuilder
    private func GoalImpactCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Goal Impact")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                DetailRow(title: "Goal", value: goal.name)
                DetailRow(title: "Current Progress", value: "\(Int(goal.progress * 100))%")
                DetailRow(title: "Remaining Amount", value: "₹\(String(format: "%.2f", goal.remainingAmount))")
                
                let newProgress = (goal.currentAmount + totalInvestment) / goal.targetAmount
                DetailRow(title: "New Progress", value: "\(Int(newProgress * 100))%", color: .blue)
                
                let timeSaved = Int(ceil(goal.remainingAmount / goal.monthlyInvestment)) - Int(ceil((goal.remainingAmount - totalInvestment) / goal.monthlyInvestment))
                if timeSaved > 0 {
                    DetailRow(title: "Time Saved", value: "\(timeSaved) months", color: .green)
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
    
    @ViewBuilder
    private func RiskSummaryCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Risk Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                RiskDetailRow(
                    title: "Risk Level",
                    value: stock.riskLevel.rawValue,
                    color: stock.riskLevel.color,
                    description: stock.riskLevel.description
                )
                
                RiskDetailRow(
                    title: "Market Trend",
                    value: stock.shortTermTrend,
                    color: getTrendColor(stock.shortTermTrend),
                    description: "Short-term market direction"
                )
                
                RiskDetailRow(
                    title: "Volatility",
                    value: "\(String(format: "%.1f", abs(stock.percentChange)))%",
                    color: abs(stock.percentChange) > 5 ? .red : .orange,
                    description: abs(stock.percentChange) > 5 ? "High volatility" : "Moderate volatility"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private func confirmInvestment() {
        viewModel.addStockInvestment(
            stock: stock,
            quantity: quantity,
            goalId: goal.id
        )
        
        withAnimation(AnimationUtils.springAnimation) {
            showingSuccess = true
        }
    }
    
    private func getTrendColor(_ trend: String) -> Color {
        switch trend.lowercased() {
        case "bullish": return .green
        case "bearish": return .red
        default: return .orange
        }
    }
}







#Preview {
    InvestmentConfirmationView(
        stock: Stock(
            ticker: "RELIANCE.BO",
            company: "Reliance Industries",
            price: 2500.0,
            percentChange: 2.5,
            netChange: 60.0,
            bid: 0,
            ask: 0,
            high: 2550.0,
            low: 2450.0,
            open: 2480.0,
            lowCircuitLimit: 2200.0,
            upCircuitLimit: 2800.0,
            volume: 1500000,
            close: 2440.0,
            overallRating: "Buy",
            shortTermTrend: "Bullish",
            longTermTrend: "Bullish",
            week52Low: 2000.0,
            week52High: 2800.0
        ),
        quantity: 10,
        goal: Goal(
            name: "Buy a House",
            targetAmount: 5000000,
            currentAmount: 2000000,
            monthlyInvestment: 50000,
            startDate: Date(),
            targetDate: Date().addingTimeInterval(365 * 24 * 60 * 60 * 2),
            category: .house
        )
    )
    .environmentObject(GoalsViewModel())
} 