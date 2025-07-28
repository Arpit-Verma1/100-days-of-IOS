//
//  StockService.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/28/25.
//

import Foundation
import Combine


class StockService: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://stock.indianapi.in"
    private let apiKey = "YOUR_API_KEY"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Fetch Most Active Stocks
    func fetchMostActiveStocks() {
        isLoading = true
        errorMessage = nil
        
        // Use the correct URL without query parameters
        guard let url = URL(string: "\(baseURL)/BSE_most_active") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        // Create request with API key authentication (matching browser headers)
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        print("Making API request to: \(url)")
        print("Request headers: \(request.allHTTPHeaderFields ?? [:])")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Check for HTTP response status
                if let httpResponse = response as? HTTPURLResponse {
                    print("Stock API Response Status: \(httpResponse.statusCode)")
                    print("Response headers: \(httpResponse.allHeaderFields)")
                    
                    if httpResponse.statusCode == 400 {
                        // Try to parse error response
                        if let errorString = String(data: data, encoding: .utf8) {
                            print("API Error Response: \(errorString)")
                        }           
                        throw URLError(.badServerResponse)
                    } else if httpResponse.statusCode != 200 {
                        throw URLError(.badServerResponse)
                    }
                }
                return data
            }
            .decode(type: [Stock].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleAPIError(error)
                    }
                },
                receiveValue: { [weak self] stocks in
                    self?.stocks = stocks
                    print("stocks are \(stocks)")
                    print("Fetched \(stocks.count) stocks successfully")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Filter Stocks by Criteria
    func filterStocks(by criteria: StockFilterCriteria) -> [Stock] {
        return stocks.filter { stock in
            var matches = true
            
            // Risk level filter
            if let riskLevel = criteria.riskLevel {
                matches = matches && stock.riskLevel == riskLevel
            }
            
            // Price range filter
            if let minPrice = criteria.minPrice {
                matches = matches && stock.price >= minPrice
            }
            if let maxPrice = criteria.maxPrice {
                matches = matches && stock.price <= maxPrice
            }
            
            // Trend filter
            if let trend = criteria.trend {
                matches = matches && stock.shortTermTrend.lowercased() == trend.lowercased()
            }
            
            // Company name filter
            if let companyName = criteria.companyName, !companyName.isEmpty {
                matches = matches && stock.company.lowercased().contains(companyName.lowercased())
            }
            
            return matches
        }
    }
    
    // MARK: - Get Top Performers
    func getTopPerformers(limit: Int = 10) -> [Stock] {
        return stocks
            .sorted { $0.percentChange > $1.percentChange }
            .prefix(limit)
            .map { $0 }
    }
    
    // MARK: - Get Best Value Stocks
    func getBestValueStocks(limit: Int = 10) -> [Stock] {
        return stocks
            .sorted { $0.potentialReturn > $1.potentialReturn }
            .prefix(limit)
            .map { $0 }
    }
    
    // MARK: - Get Low Risk Stocks
    func getLowRiskStocks(limit: Int = 10) -> [Stock] {
        return stocks
            .filter { $0.riskLevel == .low }
            .sorted { $0.potentialReturn > $1.potentialReturn }
            .prefix(limit)
            .map { $0 }
    }
    
    // MARK: - Calculate Investment Metrics
    func calculateInvestmentMetrics(for stock: Stock, quantity: Int, goal: Goal) -> InvestmentMetrics {
        let totalInvestment = stock.price * Double(quantity)
        let monthlyInvestment = goal.monthlyInvestment
        let monthsToGoal = Int(ceil(goal.remainingAmount / monthlyInvestment))
        
        // Calculate expected return based on historical performance
        let expectedReturn = stock.potentialReturn / 100
        let projectedValue = totalInvestment * (1 + expectedReturn)
        
        // Calculate time to goal with stock investment
        let additionalMonthlyReturn = (projectedValue - totalInvestment) / Double(monthsToGoal)
        let newMonthlyInvestment = monthlyInvestment + additionalMonthlyReturn
        let newMonthsToGoal = Int(ceil(goal.remainingAmount / newMonthlyInvestment))
        
        return InvestmentMetrics(
            totalInvestment: totalInvestment,
            expectedReturn: stock.potentialReturn,
            projectedValue: projectedValue,
            monthsToGoal: monthsToGoal,
            newMonthsToGoal: newMonthsToGoal,
            timeSaved: max(0, monthsToGoal - newMonthsToGoal),
            riskLevel: stock.riskLevel
        )
    }
    
    // MARK: - Refresh Data
    func refreshStocks() {
        print("Refreshing stock data...")
        
        // Clear existing stocks and show loading state
        DispatchQueue.main.async {
            self.stocks = []
            self.isLoading = true
            self.errorMessage = nil
        }
        
        // Add a small delay to show the loading state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchMostActiveStocks()
        }
    }
    
    // MARK: - Alternative Authentication Methods
    func fetchMostActiveStocksWithoutAuth() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/BSE_most_active") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate, br, zstd", forHTTPHeaderField: "Accept-Encoding")
        
        print("Trying without authentication...")
        print("Request URL: \(url)")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    print("No Auth Response Status: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        if let errorString = String(data: data, encoding: .utf8) {
                            print("No Auth Error: \(errorString)")
                        }
                        throw URLError(.badServerResponse)
                    }
                }
                return data
            }
            .decode(type: [Stock].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleAPIError(error)
                    }
                },
                receiveValue: { [weak self] stocks in
                    self?.stocks = stocks
                    print("Fetched \(stocks.count) stocks without auth")
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchMostActiveStocksWithHeaderAuth() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/BSE_most_active") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        print("Trying header authentication...")
        print("Request URL: \(url)")
        print("Request headers: \(request.allHTTPHeaderFields ?? [:])")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Header Auth Response Status: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        if let errorString = String(data: data, encoding: .utf8) {
                            print("Header Auth Error: \(errorString)")
                        }
                        throw URLError(.badServerResponse)
                    }
                }
                return data
            }
            .decode(type: [Stock].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleAPIError(error)
                    }
                },
                receiveValue: { [weak self] stocks in
                    self?.stocks = stocks
                    print("Fetched \(stocks.count) stocks with header auth")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Error Handling
    private func handleAPIError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to fetch stock data: \(error.localizedDescription)"
            print("Stock API Error: \(error)")
            
            // Load sample data if API fails
            if self.stocks.isEmpty {
                self.loadSampleData()
            }
        }
    }
    
    // MARK: - Sample Data
    private func loadSampleData() {
        print("Loading sample stock data...")
        let sampleStocks = [
            Stock(
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
            Stock(
                ticker: "TCS.BO",
                company: "Tata Consultancy Services",
                price: 3500.0,
                percentChange: 1.5,
                netChange: 50.0,
                bid: 0,
                ask: 0,
                high: 3550.0,
                low: 3450.0,
                open: 3480.0,
                lowCircuitLimit: 3100.0,
                upCircuitLimit: 3900.0,
                volume: 800000,
                close: 3450.0,
                overallRating: "Hold",
                shortTermTrend: "Neutral",
                longTermTrend: "Bullish",
                week52Low: 3000.0,
                week52High: 3800.0
            ),
            Stock(
                ticker: "INFY.BO",
                company: "Infosys",
                price: 1500.0,
                percentChange: -1.2,
                netChange: -18.0,
                bid: 0,
                ask: 0,
                high: 1520.0,
                low: 1480.0,
                open: 1510.0,
                lowCircuitLimit: 1350.0,
                upCircuitLimit: 1650.0,
                volume: 1200000,
                close: 1518.0,
                overallRating: "Sell",
                shortTermTrend: "Bearish",
                longTermTrend: "Neutral",
                week52Low: 1400.0,
                week52High: 1600.0
            )
        ]
        
        DispatchQueue.main.async {
            self.stocks = sampleStocks
            print("Loaded \(sampleStocks.count) sample stocks")
        }
    }
}

// MARK: - Supporting Models
struct StockFilterCriteria {
    let riskLevel: RiskLevel?
    let minPrice: Double?
    let maxPrice: Double?
    let trend: String?
    let companyName: String?
}

struct InvestmentMetrics {
    let totalInvestment: Double
    let expectedReturn: Double
    let projectedValue: Double
    let monthsToGoal: Int
    let newMonthsToGoal: Int
    let timeSaved: Int
    let riskLevel: RiskLevel
    
    var timeSavedPercentage: Double {
        guard monthsToGoal > 0 else { return 0 }
        return (Double(timeSaved) / Double(monthsToGoal)) * 100
    }
    
    var monthlyReturn: Double {
        (projectedValue - totalInvestment) / Double(monthsToGoal)
    }
} 
