//
//  StockComparisonView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/28/25.
//

import SwiftUI

struct StockComparisonView: View {
    let comparison: StockComparison
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    ComparisonHeaderView(comparison: comparison)
                    
                    // Stock comparison cards
                    HStack(spacing: 15) {
                        StockComparisonCard(
                            recommendation: comparison.stock1,
                            isWinner: comparison.winner.id == comparison.stock1.id
                        )
                        
                        StockComparisonCard(
                            recommendation: comparison.stock2,
                            isWinner: comparison.winner.id == comparison.stock2.id
                        )
                    }
                    
                    // Comparison summary
                    ComparisonSummaryView(comparison: comparison)
                    
                    // Advantages and disadvantages
                    ComparisonDetailsView(comparison: comparison)
                    
                    // Action buttons
                    ComparisonActionButtonsView(comparison: comparison)
                }
                .padding()
            }
            .navigationTitle("Stock Comparison")
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
}

struct ComparisonHeaderView: View {
    let comparison: StockComparison
    
    var body: some View {
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
                
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            Text("Stock Comparison")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(comparison.comparison)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct StockComparisonCard: View {
    let recommendation: StockRecommendation
    let isWinner: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Winner badge
            if isWinner {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    Text("Winner")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow.opacity(0.2))
                )
            }
            
            // Company info
            if let stock = recommendation.stock {
                VStack(spacing: 5) {
                    Text(stock.company)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(stock.ticker)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Stock information not available")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            
            // Key metrics
            VStack(spacing: 8) {
                MetricRow(
                    title: "Confidence",
                    value: "\(Int((recommendation.confidence ?? 0) * 100))%",
                    color: recommendation.confidenceColor
                )
                
                MetricRow(
                    title: "Expected Return",
                    value: "\(String(format: "%.1f", recommendation.displayExpectedReturn))%",
                    color: .green
                )
                
                MetricRow(
                    title: "Time to Goal",
                    value: recommendation.displayTimeToGoalText,
                    color: .blue
                )
                
                MetricRow(
                    title: "Investment",
                    value: CurrencyFormatter.formatCompact(recommendation.displayExpectedReturn * 1000), // Placeholder calculation
                    color: .primary
                )
                
                if let stock = recommendation.stock {
                    MetricRow(
                        title: "Risk Level",
                        value: stock.riskLevel.rawValue,
                        color: stock.riskLevel.color
                    )
                }
            }
            
            // Goal info
            VStack(spacing: 3) {
                Text("For Goal:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(recommendation.displayGoal)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isWinner ? Color.yellow : Color.clear, lineWidth: 2)
        )
    }
}



struct ComparisonSummaryView: View {
    let comparison: StockComparison
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Comparison Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                SummaryRow(
                    title: "Winner",
                    value: comparison.winner.displayName,
                    color: .green
                )
                
                let confidence1 = comparison.stock1.confidence ?? 0
                let confidence2 = comparison.stock2.confidence ?? 0
                SummaryRow(
                    title: "Confidence Difference",
                    value: "\(Int(abs(confidence1 - confidence2) * 100))%",
                    color: .blue
                )
                
                let return1 = comparison.stock1.displayExpectedReturn
                let return2 = comparison.stock2.displayExpectedReturn
                SummaryRow(
                    title: "Return Difference",
                    value: "\(String(format: "%.1f", abs(return1 - return2)))%",
                    color: .orange
                )
                
                let time1 = comparison.stock1.displayTimeToGoal
                let time2 = comparison.stock2.displayTimeToGoal
                SummaryRow(
                    title: "Time Difference",
                    value: "\(abs(time1 - time2)) years",
                    color: .purple
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
}



struct ComparisonDetailsView: View {
    let comparison: StockComparison
    
    var body: some View {
        VStack(spacing: 20) {
            // Advantages
            VStack(alignment: .leading, spacing: 15) {
                Text("Advantages")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(comparison.advantages, id: \.self) { advantage in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            
                            Text(advantage)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.green.opacity(0.1))
            )
            
            // Disadvantages
            VStack(alignment: .leading, spacing: 15) {
                Text("Considerations")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(comparison.disadvantages, id: \.self) { disadvantage in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            
                            Text(disadvantage)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.orange.opacity(0.1))
            )
        }
    }
}

struct ComparisonActionButtonsView: View {
    let comparison: StockComparison
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingInvestmentSheet = false
    @State private var selectedGoal: Goal?
    @State private var quantity = ""
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                // Show investment sheet for winner
                showingInvestmentSheet = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Winner to Portfolio")
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
        }
        .sheet(isPresented: $showingInvestmentSheet) {
            if let winnerStock = comparison.winner.stock {
                ComparisonInvestmentView(
                    stock: winnerStock,
                    recommendation: comparison.winner,
                    isPresented: $showingInvestmentSheet
                )
                .environmentObject(viewModel)
            } else {
                VStack {
                    Text("Stock Information Unavailable")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("Cannot add this stock to portfolio due to missing information.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("OK") {
                        showingInvestmentSheet = false
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}

struct ComparisonInvestmentView: View {
    let stock: Stock
    let recommendation: StockRecommendation
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var selectedGoal: Goal?
    @State private var quantity = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Winner header
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "crown.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        
                        Text("Add Winner to Portfolio")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(stock.company) - \(stock.ticker)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Recommendation summary
                    VStack(alignment: .leading, spacing: 15) {
                        Text("AI Recommendation")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Confidence", value: "\(Int((recommendation.confidence ?? 0) * 100))%", color: recommendation.confidenceColor)
                            DetailRow(title: "Expected Return", value: "\(String(format: "%.1f", recommendation.displayExpectedReturn))%", color: .green)
                            DetailRow(title: "Time to Goal", value: recommendation.displayTimeToGoalText, color: .blue)
                            DetailRow(title: "Risk Assessment", value: recommendation.displayRiskAssessment, color: .orange)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Investment form
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Investment Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            // Goal selection
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Select Goal")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                if viewModel.goals.isEmpty {
                                    Text("No goals available. Please create a goal first.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.red.opacity(0.1))
                                        )
                                } else {
                                    Picker("Select Goal", selection: $selectedGoal) {
                                        Text("Choose a goal").tag(nil as Goal?)
                                        ForEach(viewModel.goals) { goal in
                                            Text(goal.name).tag(goal as Goal?)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                            }
                            
                            // Quantity input
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Quantity")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Enter quantity", text: $quantity)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Investment summary
                            if let qty = Int(quantity), qty > 0 {
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Total Investment:")
                                        Spacer()
                                        Text("₹\(String(format: "%.2f", stock.price * Double(qty)))")
                                            .fontWeight(.semibold)
                                    }
                                    
                                    HStack {
                                        Text("Expected Return:")
                                        Spacer()
                                        Text("₹\(String(format: "%.2f", stock.price * Double(qty) * stock.potentialReturn / 100))")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.green)
                                    }
                                }
                                .font(.subheadline)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            if let goal = selectedGoal, let qty = Int(quantity), qty > 0 {
                                viewModel.addStockInvestment(
                                    stock: stock,
                                    quantity: qty,
                                    goalId: goal.id
                                )
                                showingConfirmation = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add to Portfolio")
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
                        .disabled(quantity.isEmpty || selectedGoal == nil)
                        
                        Button(action: {
                            isPresented = false
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
                }
                .padding()
            }
            .navigationTitle("Add Winner")
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
                        isPresented = false
                    }
                }
            }
            .alert("Investment Added!", isPresented: $showingConfirmation) {
                Button("OK") {
                    isPresented = false
                }
            } message: {
                Text("\(stock.company) has been added to your portfolio successfully!")
            }
        }
    }
}
 
