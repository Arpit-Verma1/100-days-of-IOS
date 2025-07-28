import SwiftUI

//
//  DashboardView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

struct DashboardView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var animateProgress = false
    @State private var animateStats = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    OverallProgressCard()
                    QuickStatsView()
                    StockInvestmentsView()
                    RecentGoalsView()
                    MotivationalQuoteView()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .onAppear {
            withAnimation(AnimationUtils.springAnimation.delay(0.3)) {
                animateProgress = true
            }
            withAnimation(AnimationUtils.springAnimation.delay(0.5)) {
                animateStats = true
            }
        }
    }
}

struct OverallProgressCard: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Overall Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Your investment journey")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.getOverallProgress())
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(AnimationUtils.springAnimation.delay(0.5), value: viewModel.getOverallProgress())
                    
                    Text("\(Int(viewModel.getOverallProgress() * 100))%")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Invested")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.formatCompact(viewModel.getTotalInvested()))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Total Target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.formatCompact(viewModel.getTotalTarget()))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct QuickStatsView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            StatCard(
                title: "Active Goals",
                value: "\(viewModel.goals.filter { !$0.isCompleted }.count)",
                icon: "target",
                color: .blue
            )
            
            StatCard(
                title: "Completed",
                value: "\(viewModel.goals.filter { $0.isCompleted }.count)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCard(
                title: "Stock Investments",
                value: "\(viewModel.stockInvestments.count)",
                icon: "chart.line.uptrend.xyaxis",
                color: .orange
            )
            
            StatCard(
                title: "Total Portfolio",
                value: CurrencyFormatter.formatCompact(viewModel.getTotalInvested()),
                icon: "banknote.fill",
                color: .purple
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct StockInvestmentsView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Stock Portfolio")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !viewModel.stockInvestments.isEmpty {
                    NavigationLink(destination: StockRecommendationsView()) {
                        Text("View All")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            if viewModel.stockInvestments.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    Text("No Stock Investments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Start investing in stocks to grow your wealth")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray6))
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.stockInvestments.prefix(3)) { investment in
                            StockInvestmentCard(investment: investment)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct StockInvestmentCard: View {
    let investment: StockInvestment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(investment.stock.company)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(investment.stock.ticker)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(investment.quantity) shares")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Investment")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.formatCompact(investment.investmentAmount))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Current Value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.formatCompact(investment.stock.price * Double(investment.quantity)))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
    }
}

struct RecentGoalsView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var recentGoals: [Goal] {
        return Array(viewModel.goals.prefix(3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Goals")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                NavigationLink(destination: GoalsListView()) {
                    Text("View All")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if recentGoals.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "target")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    Text("No Goals Yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Create your first goal to start tracking")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray6))
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(recentGoals) { goal in
                        RecentGoalRow(goal: goal)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct RecentGoalRow: View {
    let goal: Goal
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(goal.category.gradient)
                    .frame(width: 40, height: 40)
                
                Image(systemName: goal.category.icon)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(goal.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("\(Int(goal.progress * 100))% complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(CurrencyFormatter.formatCompact(goal.currentAmount))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("of \(CurrencyFormatter.formatCompact(goal.targetAmount))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}

struct MotivationalQuoteView: View {
    let quotes = [
        "The best investment you can make is in yourself.",
        "Compound interest is the eighth wonder of the world.",
        "Don't save what is left after spending, but spend what is left after saving.",
        "The stock market is a device for transferring money from the impatient to the patient.",
        "Investing should be more like watching paint dry or watching grass grow."
    ]
    
    @State private var currentQuote = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "quote.bubble.fill")
                .font(.title)
                .foregroundColor(.blue)
            
            Text(currentQuote)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .italic()
            
            Text("— Warren Buffett")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .onAppear {
            currentQuote = quotes.randomElement() ?? quotes[0]
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(GoalsViewModel())
} 
