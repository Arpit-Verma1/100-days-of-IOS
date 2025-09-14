//
//  AnalyticsView.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Portfolio Card
                    portfolioCard
                        .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Drawer action
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Notification action
                    }) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
        }
    }
}

extension AnalyticsView {
    private var portfolioCard: some View {
        VStack(spacing: 0) {
            // Portfolio Card Container
            VStack(spacing: 16) {
                // First Row: Portfolio Value with toggle
                HStack {
                    HStack(spacing: 8) {
                        Text("Portfolio Value")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Currency Toggle
                    CurrencyToggleView(
                        isBitcoinMode: $viewModel.isBitcoinMode,
                        onToggle: viewModel.toggleCurrencyMode
                    )
                }
                
                // Second Row: Amount
                HStack {
                    Text(viewModel.portfolioValue)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.theme.blue, Color.theme.black]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .padding(.horizontal, 20)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
