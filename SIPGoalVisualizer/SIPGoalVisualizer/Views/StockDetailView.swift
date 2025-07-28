import SwiftUI

struct StockDetailView: View {
    let stock: Stock
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = ""
    @State private var selectedGoal: Goal?
    @State private var showingInvestmentSheet = false

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stock header
                    StockHeaderView(stock: stock)
                    
                    // Price and performance
                    PricePerformanceView(stock: stock)
                    
                    // Technical indicators
                    TechnicalIndicatorsView(stock: stock)
                    
                    // Investment calculator
                    InvestmentCalculatorView(
                        stock: stock,
                        quantity: $quantity,
                        selectedGoal: $selectedGoal,
                        onInvest: { newGoal, newQuantity in
                            
                            print("StockDetailView: onInvest called with goal: \(newGoal.name), quantity: \(newQuantity)")
                            print("StockDetailView: Current selectedGoal: \(selectedGoal?.name ?? "nil")")
                            self.selectedGoal = newGoal
                            self.quantity = newQuantity
                            showingInvestmentSheet = true
                            
                           
                        }
                    )
                    
                    // Risk assessment
                    RiskAssessmentView(stock: stock)
                }
                .padding()
            }
            .navigationTitle(stock.company)
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
                InvestmentSheetView(
                        goal: Goal(
                            name: "MacBook Pro",
                            targetAmount: 120000,
                            currentAmount: 90000,
                            monthlyInvestment: 3000,
                            startDate: Date().addingTimeInterval(-120 * 24 * 60 * 60),
                            targetDate: Date().addingTimeInterval(30 * 24 * 60 * 60),
                            category: .gadget
                        ),
                        quantity: "10",
                        stock: stock,
                        isPresented: $showingInvestmentSheet
                    )
            }
        }
        .onAppear {
            print("StockDetailView: View appeared")
            print("StockDetailView: Available goals count: \(viewModel.goals.count)")
            print("StockDetailView: Goals: \(viewModel.goals.map { $0.name })")
            
            // Ensure goals are loaded
            if viewModel.goals.isEmpty {
                print("StockDetailView: No goals found, loading sample data")
                viewModel.loadSampleData()
            }
        }
    }
}
struct InvestmentSheetView: View {
    let goal: Goal?
    let quantity: String
    let stock: Stock
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: GoalsViewModel

    var body: some View {
        if let goal = goal, let qty = Int(quantity), qty > 0 {
            InvestmentConfirmationView(
                stock: stock,
                quantity: qty,
                goal: goal
            )
            .environmentObject(viewModel)
        } else {
            VStack {
                Text("Invalid Investment Data")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)

                Text("Please ensure you have selected a goal and entered a valid quantity.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()

                Button("OK") {
                    isPresented = false
                }
                .padding()
            }
            .padding()
        }
    }
}

struct InvestmentCalculatorView: View {
    let stock: Stock
    @Binding var quantity: String
    @Binding var selectedGoal: Goal?
    let onInvest: (Goal, String) -> Void
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var totalInvestment: Double {
        guard let qty = Int(quantity) else { return 0 }
        return stock.price * Double(qty)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Investment Calculator")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                // Quantity input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Quantity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter quantity", text: $quantity)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
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
                        .onChange(of: selectedGoal) { _, newValue in
                            selectedGoal = newValue
                            print("InvestmentCalculatorView: Goal changed to: \(newValue?.name ?? "nil")")
                        }
                        .onTapGesture {
                            print("InvestmentCalculatorView: Picker tapped")
                            print("InvestmentCalculatorView: Current selectedGoal: \(selectedGoal?.name ?? "nil")")
                        }
                    }
                }
                
                // Debug info
                if let selectedGoal = selectedGoal {
                    Text("Selected: \(selectedGoal.name)")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("No goal selected")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                // Additional debug info
                Text("Available goals: \(viewModel.goals.count)")
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                Text("Goals: \(viewModel.goals.map { $0.name }.joined(separator: ", "))")
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                // Investment summary
                if let qty = Int(quantity), qty > 0 {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Total Investment:")
                            Spacer()
                            Text("₹\(String(format: "%.2f", totalInvestment))")
                                .fontWeight(.semibold)
                        }
                        
                        HStack {
                            Text("Expected Return:")
                            Spacer()
                            Text("₹\(String(format: "%.2f", totalInvestment * stock.potentialReturn / 100))")
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
                
                // Invest button
                Button(action: {
                    print("InvestmentCalculatorView: Invest button tapped")
                    print("InvestmentCalculatorView: Quantity: '\(quantity)'")
                    print("InvestmentCalculatorView: Selected goal: \(selectedGoal?.name ?? "nil")")
                    print("InvestmentCalculatorView: Button disabled: \(quantity.isEmpty || selectedGoal == nil)")
                    if let selectedGoal = selectedGoal  {
                        onInvest(selectedGoal, quantity)
                    }
                }) {
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
                .disabled(quantity.isEmpty || selectedGoal == nil)
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

struct StockHeaderView: View {
    let stock: Stock
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(stock.company)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(stock.ticker)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Risk level badge
                HStack(spacing: 5) {
                    Circle()
                        .fill(stock.riskLevel.color)
                        .frame(width: 10, height: 10)
                    
                    Text(stock.riskLevel.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(stock.riskLevel.color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(stock.riskLevel.color.opacity(0.1))
                )
            }
            
            // Current price
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("₹\(String(format: "%.2f", stock.price))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Image(systemName: stock.isPositive ? "arrow.up.right" : "arrow.down.right")
                                .font(.caption)
                                .foregroundColor(stock.priceColor)
                            
                            Text("\(String(format: "%.2f", abs(stock.percentChange)))%")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(stock.priceColor)
                        }
                        
                        Text("(₹\(String(format: "%.2f", abs(stock.netChange))))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Potential Return")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", stock.potentialReturn))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
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
}

struct PricePerformanceView: View {
    let stock: Stock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Price Performance")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                PriceRow(title: "Open", value: "₹\(String(format: "%.2f", stock.open))")
                PriceRow(title: "High", value: "₹\(String(format: "%.2f", stock.high))", color: .green)
                PriceRow(title: "Low", value: "₹\(String(format: "%.2f", stock.low))", color: .red)
                PriceRow(title: "Close", value: "₹\(String(format: "%.2f", stock.close))")
                PriceRow(title: "Volume", value: "\(stock.volume.formatted())")
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



struct TechnicalIndicatorsView: View {
    let stock: Stock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Technical Indicators")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                IndicatorRow(
                    title: "Overall Rating",
                    value: stock.overallRating,
                    color: getRatingColor(stock.overallRating)
                )
                
                IndicatorRow(
                    title: "Short Term Trend",
                    value: stock.shortTermTrend,
                    color: getTrendColor(stock.shortTermTrend)
                )
                
                IndicatorRow(
                    title: "Long Term Trend",
                    value: stock.longTermTrend,
                    color: getTrendColor(stock.longTermTrend)
                )
                
                IndicatorRow(
                    title: "52-Week High",
                    value: "₹\(String(format: "%.2f", stock.week52High))",
                    color: .green
                )
                
                IndicatorRow(
                    title: "52-Week Low",
                    value: "₹\(String(format: "%.2f", stock.week52Low))",
                    color: .red
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
    
    private func getRatingColor(_ rating: String) -> Color {
        switch rating.lowercased() {
        case "buy": return .green
        case "sell": return .red
        case "hold": return .orange
        default: return .secondary
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





struct RiskAssessmentView: View {
    let stock: Stock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Risk Assessment")
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
                    title: "Volatility",
                    value: "\(String(format: "%.1f", abs(stock.percentChange)))%",
                    color: abs(stock.percentChange) > 5 ? .red : .orange,
                    description: abs(stock.percentChange) > 5 ? "High volatility" : "Moderate volatility"
                )
                
                RiskDetailRow(
                    title: "Volume",
                    value: "\(stock.volume.formatted())",
                    color: stock.volume > 1000000 ? .green : .orange,
                    description: stock.volume > 1000000 ? "High liquidity" : "Moderate liquidity"
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

