//
//  AnalyticsViewModel.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import Foundation
import SwiftUI

class AnalyticsViewModel: ObservableObject {
    @Published var portfolioValue: String = "₹ 1,57,342.05"
    @Published var isBitcoinMode: Bool = true
    @Published var isLoading: Bool = false
    
    // Mock data - in real app this would come from API
    @Published var portfolioData: PortfolioData = PortfolioData(
        totalValue: 157342.05,
        currency: "INR",
        bitcoinValue: 157342.05,
        dollarValue: 1892.45
    )
    
    func toggleCurrencyMode() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isBitcoinMode.toggle()
            updatePortfolioValue()
        }
    }
    
    private func updatePortfolioValue() {
        if isBitcoinMode {
            portfolioValue = "₹ \(String(format: "%.2f", portfolioData.bitcoinValue))"
        } else {
            portfolioValue = "$ \(String(format: "%.2f", portfolioData.dollarValue))"
        }
    }
}

struct PortfolioData {
    let totalValue: Double
    let currency: String
    let bitcoinValue: Double
    let dollarValue: Double
}
