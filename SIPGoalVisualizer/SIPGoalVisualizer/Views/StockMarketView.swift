//
//  StockMarketView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/28/25.
//

import SwiftUI

struct StockMarketView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var selectedFilter: StockFilter = .all
    @State private var searchText = ""
    @State private var showingRecommendations = false
    @State private var animateCards = false
    @State private var hasLoadedStocks = false
    
    enum StockFilter: String, CaseIterable {
        case all = "All"
        case topPerformers = "Top Performers"
        case lowRisk = "Low Risk"
        case bestValue = "Best Value"
    }
    
    var filteredStocks: [Stock] {
        let stocks = viewModel.getStocks()
        print("filteredStocks: Total stocks = \(stocks.count)")
        
        let filtered = stocks.filter { stock in
            if !searchText.isEmpty {
                return stock.company.lowercased().contains(searchText.lowercased()) ||
                       stock.ticker.lowercased().contains(searchText.lowercased())
            }
            return true
        }
        
        let result: [Stock]
        switch selectedFilter {
        case .all:
            result = filtered
        case .topPerformers:
            result = filtered.filter { $0.percentChange > 0 }
                .sorted { $0.percentChange > $1.percentChange }
        case .lowRisk:
            result = filtered.filter { $0.riskLevel == .low }
                .sorted { $0.potentialReturn > $1.potentialReturn }
        case .bestValue:
            result = filtered.sorted { $0.potentialReturn > $1.potentialReturn }
        }
        
        print("filteredStocks: Filtered result = \(result.count)")
        return result
    }
    
    var body: some View {
        let _ = print("StockMarketView: Rendering with \(viewModel.stockCount) stocks, filtered: \(filteredStocks.count)")
        return NavigationView {
            VStack(spacing: 0) {
                // Header with market stats
                MarketStatsHeader()
                
                // Filter and search
                FilterSearchView(
                    selectedFilter: $selectedFilter,
                    searchText: $searchText
                )
                
                // Stock list
                if viewModel.isStockLoading {
                    StockMarketLoadingView()
                } else if filteredStocks.isEmpty {
                    if viewModel.stockCount == 0 {
                        StockMarketEmptyStateView()
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No stocks match your filter")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Try adjusting your search or filter criteria")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(Array(filteredStocks.enumerated()), id: \.element.id) { index, stock in
                                StockCardView(stock: stock)
                                    .offset(y: animateCards ? 0 : 50)
                                    .opacity(animateCards ? 1 : 0)
                                    .animation(
                                        AnimationUtils.springAnimation.delay(Double(index) * 0.1),
                                        value: animateCards
                                    )
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.refreshStocks()
                    }
                }
            }
            .navigationTitle("Stock Market")
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
                    Menu {
                        Button("Get Recommendations") {
                            showingRecommendations = true
                        }
                        .disabled(viewModel.stockCount == 0 || viewModel.goals.isEmpty)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingRecommendations) {
                StockRecommendationsView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            if !hasLoadedStocks {
                viewModel.fetchStocks()
                hasLoadedStocks = true
            }
            withAnimation(AnimationUtils.springAnimation.delay(0.3)) {
                animateCards = true
            }
        }
        .onChange(of: viewModel.stockCount) { _ in
            // Trigger animation when stocks are loaded
            withAnimation(AnimationUtils.springAnimation.delay(0.1)) {
                animateCards = true
            }
        }
    }
}

struct MarketStatsHeader: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var gainersCount: Int {
        viewModel.getStocks().filter { $0.percentChange > 0 }.count
    }
    
    var losersCount: Int {
        viewModel.getStocks().filter { $0.percentChange < 0 }.count
    }
    
    var bullishCount: Int {
        viewModel.getStocks().filter { $0.shortTermTrend.lowercased() == "bullish" }.count
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Market Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(viewModel.isStockLoading ? "Refreshing..." : "\(viewModel.stockCount) active stocks")
                        .font(.caption)
                        .foregroundColor(viewModel.isStockLoading ? .blue : .secondary)
                        .onAppear {
                            print("MarketStatsHeader: Stock count = \(viewModel.stockCount)")
                        }
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.refreshStocks()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(viewModel.isStockLoading ? 360 : 0))
                        .animation(
                            viewModel.isStockLoading ? 
                                Animation.linear(duration: 1).repeatForever(autoreverses: false) : 
                                .default,
                            value: viewModel.isStockLoading
                        )
                }
                .disabled(viewModel.isStockLoading)
            }
            
            // Market stats
            HStack(spacing: 20) {
                MarketStatCard(
                    title: "Gainers",
                    value: viewModel.isStockLoading ? "..." : "\(gainersCount)",
                    color: viewModel.isStockLoading ? .gray : .green
                )
                
                MarketStatCard(
                    title: "Losers",
                    value: viewModel.isStockLoading ? "..." : "\(losersCount)",
                    color: viewModel.isStockLoading ? .gray : .red
                )
                
                MarketStatCard(
                    title: "Bullish",
                    value: viewModel.isStockLoading ? "..." : "\(bullishCount)",
                    color: viewModel.isStockLoading ? .gray : .blue
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct MarketStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1))
        )
    }
}

struct FilterSearchView: View {
    @Binding var selectedFilter: StockMarketView.StockFilter
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 15) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search stocks...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
            
            // Filter buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(StockMarketView.StockFilter.allCases, id: \.self) { filter in
                        FilterButton(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation(AnimationUtils.springAnimation) {
                                selectedFilter = filter
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
    }
}

struct StockCardView: View {
    let stock: Stock
    @State private var showDetail = false
    
    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            VStack(spacing: 0) {
                // Header with company info
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(stock.company)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(stock.ticker)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Risk level indicator
                    HStack(spacing: 5) {
                        Circle()
                            .fill(stock.riskLevel.color)
                            .frame(width: 8, height: 8)
                        
                        Text(stock.riskLevel.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Price and change info
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("₹\(String(format: "%.2f", stock.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 5) {
                            Image(systemName: stock.isPositive ? "arrow.up.right" : "arrow.down.right")
                                .font(.caption)
                                .foregroundColor(stock.priceColor)
                            
                            Text("\(String(format: "%.2f", abs(stock.percentChange)))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(stock.priceColor)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("Potential")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(String(format: "%.1f", stock.potentialReturn))%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .sheet(isPresented: $showDetail) {
            StockDetailView(stock: stock)
                .environmentObject(GoalsViewModel())
        }
    }
}

struct StockMarketLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            Text("Refreshing Market Data")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Fetching the latest stock market information...")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            isAnimating = true
        }
    }
}

struct StockMarketEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Market Data")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Tap the refresh button to load stock market data")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    StockMarketView()
        .environmentObject(GoalsViewModel())
}   
