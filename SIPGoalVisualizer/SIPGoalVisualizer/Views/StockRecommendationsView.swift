//
//  StockRecommendationsView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/28/25.
//

import SwiftUI

struct StockRecommendationsView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isGenerating = false
    @State private var selectedGoal: Goal?
    @State private var showingComparison = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isGenerating {
                    GeneratingView()
                        .transition(.opacity.combined(with: .scale))
                } else if viewModel.stockRecommendations.isEmpty {
                    StartAnalysisView( isGenerating: $isGenerating)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    RecommendationsListView()
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isGenerating)
            .animation(.easeInOut(duration: 0.5), value: viewModel.stockRecommendations.isEmpty)
            .navigationTitle("AI Recommendations")
            .navigationBarTitleDisplayMode(.large)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                if !viewModel.stockRecommendations.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Compare") {
                            showingComparison = true
                        }
                        .disabled(viewModel.selectedStocksForComparison.count != 2)
                    }
                }
            }
            .sheet(isPresented: $showingComparison) {
                if let comparison = viewModel.compareStocks() {
                    StockComparisonView(comparison: comparison)
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

struct StartAnalysisView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @Binding  var isGenerating : Bool
    @State private var showingInvestmentPreferences = false
    @State private var investmentAmount: Double = 10000
    @State private var riskTolerance: RiskLevel = .medium
    
    var body: some View {
        VStack(spacing: 30) {
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
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                Text("AI Stock Recommendations")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Get personalized stock recommendations based on your goals and investment preferences")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Goals summary
            VStack(alignment: .leading, spacing: 15) {
                Text("Your Goals")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                ForEach(viewModel.goals) { goal in
                    GoalSummaryRow(goal: goal)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            // Investment Preferences Summary
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Investment Preferences")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button("Edit") {
                        showingInvestmentPreferences = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                
                VStack(spacing: 10) {
                    PreferenceRow(
                        title: "Investment Amount",
                        value: "₹\(CurrencyFormatter.formatCompact(investmentAmount))",
                        icon: "indianrupeesign.circle"
                    )
                    
                    PreferenceRow(
                        title: "Risk Tolerance",
                        value: riskTolerance.rawValue,
                        icon: "shield.checkered",
                        color: riskTolerance.color
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            // Start analysis button
            Button(action: {
                // Add haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                isGenerating = true
                Task {
                    let preferences = UserPreferences(
                        riskTolerance: riskTolerance,
                        investmentHorizon: 60, // Default to 5 years
                        preferredSectors: [],
                        maxInvestmentPerStock: investmentAmount, // Use total amount as max per stock
                        totalInvestmentAmount: investmentAmount
                    )
                    await viewModel.generateStockRecommendations(preferences: preferences)
                    isGenerating = false
                }
            }) {
                HStack {
                    Image(systemName: "brain.head.profile")
                    Text("Start AI Analysis")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
            .padding(.horizontal)
            .disabled(  isGenerating)
        }
        .padding()
        .sheet(isPresented: $showingInvestmentPreferences) {
            InvestmentPreferencesView(
                investmentAmount: $investmentAmount,
                riskTolerance: $riskTolerance
            )
        }
    }
}

struct GoalSummaryRow: View {
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
            
            VStack(alignment: .leading, spacing: 3) {
                Text(goal.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("₹\(CurrencyFormatter.formatCompact(goal.remainingAmount)) remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(goal.progress * 100))%")
                                    .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

struct GeneratingView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var currentImageIndex = 0
    @State private var currentMessageIndex = 0
    @State private var isImageAnimating = false
    
    // Animated images for different analysis phases
    private let analysisImages = [
        ("chart.line.uptrend.xyaxis", "Market Analysis"),
        ("brain.head.profile", "AI Processing"),
        ("target", "Goal Matching"),
        ("chart.bar.fill", "Data Analysis"),
        ("lightbulb.fill", "Generating Insights"),
        ("checkmark.circle.fill", "Finalizing")
    ]
    
    // Messages that change during analysis
    private let analysisMessages = [
        "Analyzing market trends and stock performance...",
        "Processing your financial goals and investment preferences...",
        "Matching stocks with your specific objectives...",
        "Calculating risk-reward ratios and time projections...",
        "Generating personalized investment recommendations...",
        "Finalizing your AI-powered stock analysis..."
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated AI Brain Icon
            VStack(spacing: 25) {
                ZStack {
                    // Background glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.3), .purple.opacity(0.1), .clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(isImageAnimating ? 1.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: isImageAnimating
                        )
                    
                    // Main icon container
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Animated icon
                    Image(systemName: analysisImages[currentImageIndex].0)
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(isImageAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isImageAnimating
                        )
                }
                
                // Progress indicator
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: viewModel.llmService.analysisProgress)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.blue, .purple, .blue]),
                                    center: .center,
                                    startAngle: .degrees(-90),
                                    endAngle: .degrees(270)
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.5), value: viewModel.llmService.analysisProgress)
                        
                        Text("\(Int(viewModel.llmService.analysisProgress * 100))%")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Text(analysisImages[currentImageIndex].1)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            
            // Animated message
            VStack(spacing: 15) {
                Text(analysisMessages[currentMessageIndex])
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                
                // Animated dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isImageAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isImageAnimating
                            )
                    }
                }
            }
            
            // Analysis steps with enhanced animations
            VStack(alignment: .leading, spacing: 15) {
                Text("AI Analysis Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    AnalysisStepRow(
                        step: "Market Analysis",
                        isCompleted: viewModel.llmService.analysisProgress >= 0.2,
                        icon: "chart.line.uptrend.xyaxis",
                        progress: min(viewModel.llmService.analysisProgress / 0.2, 1.0)
                    )
                    
                    AnalysisStepRow(
                        step: "Goal Processing",
                        isCompleted: viewModel.llmService.analysisProgress >= 0.4,
                        icon: "target",
                        progress: min(max(0, (viewModel.llmService.analysisProgress - 0.2) / 0.2), 1.0)
                    )
                    
                    AnalysisStepRow(
                        step: "Risk Assessment",
                        isCompleted: viewModel.llmService.analysisProgress >= 0.6,
                        icon: "shield.checkered",
                        progress: min(max(0, (viewModel.llmService.analysisProgress - 0.4) / 0.2), 1.0)
                    )
                    
                    AnalysisStepRow(
                        step: "Recommendation Engine",
                        isCompleted: viewModel.llmService.analysisProgress >= 0.8,
                        icon: "brain.head.profile",
                        progress: min(max(0, (viewModel.llmService.analysisProgress - 0.6) / 0.2), 1.0)
                    )
                    
                    AnalysisStepRow(
                        step: "Finalizing Results",
                        isCompleted: viewModel.llmService.analysisProgress >= 1.0,
                        icon: "checkmark.circle.fill",
                        progress: min(max(0, (viewModel.llmService.analysisProgress - 0.8) / 0.2), 1.0)
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
            
            Spacer()
        }
        .onAppear {
            startAnimations()
        }
        .onChange(of: viewModel.llmService.analysisProgress) { progress in
            updateContentBasedOnProgress(progress)
        }
    }
    
    private func startAnimations() {
        isImageAnimating = true
        
        // Start image rotation timer
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentImageIndex = (currentImageIndex + 1) % analysisImages.count
            }
        }
        
        // Start message rotation timer
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentMessageIndex = (currentMessageIndex + 1) % analysisMessages.count
            }
        }
    }
    
    private func updateContentBasedOnProgress(_ progress: Double) {
        // Update image based on progress
        let newImageIndex: Int
        switch progress {
        case 0.0..<0.2:
            newImageIndex = 0 // Market Analysis
        case 0.2..<0.4:
            newImageIndex = 1 // AI Processing
        case 0.4..<0.6:
            newImageIndex = 2 // Goal Matching
        case 0.6..<0.8:
            newImageIndex = 3 // Data Analysis
        case 0.8..<1.0:
            newImageIndex = 4 // Generating Insights
        default:
            newImageIndex = 5 // Finalizing
        }
        
        if newImageIndex != currentImageIndex {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentImageIndex = newImageIndex
            }
        }
    }
}

struct AnalysisStepRow: View {
    let step: String
    let isCompleted: Bool
    let icon: String
    let progress: Double
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon with progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                    .frame(width: 30, height: 30)
                
                if progress > 0 && progress < 1.0 {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                        )
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
                
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(isCompleted ? .green : (progress > 0 ? .blue : .gray))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(step)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isCompleted ? .primary : (progress > 0 ? .primary : .secondary))
                
                if progress > 0 && progress < 1.0 {
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical, 5)
        .contentShape(Rectangle())
    }
}

struct RecommendationsListView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var selectedGoalFilter: Goal?
    
    var filteredRecommendations: [StockRecommendation] {
        if let selectedGoal = selectedGoalFilter {
            return viewModel.stockRecommendations.filter { $0.goal?.id == selectedGoal.id }
        }
        return viewModel.stockRecommendations
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter by goal
            GoalFilterView(
                goals: viewModel.goals,
                selectedGoal: $selectedGoalFilter
            )
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(filteredRecommendations) { recommendation in
                        RecommendationCardView(
                            recommendation: recommendation,
                            isSelected: viewModel.selectedStocksForComparison.contains { $0.id == recommendation.id }
                        ) {
                            viewModel.selectStockForComparison(recommendation)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct GoalFilterView: View {
    let goals: [Goal]
    @Binding var selectedGoal: Goal?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                // All goals option
                GoalFilterButton(
                    title: "All Goals",
                    isSelected: selectedGoal == nil
                ) {
                    selectedGoal = nil
                }
                
                // Individual goals
                ForEach(goals) { goal in
                    GoalFilterButton(
                        title: goal.name,
                        isSelected: selectedGoal?.id == goal.id
                    ) {
                        selectedGoal = goal
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
}

struct GoalFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
    }
}

struct RecommendationCardView: View {
    let recommendation: StockRecommendation
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var showDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(recommendation.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(recommendation.displayGoal)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Confidence indicator
                VStack(spacing: 3) {
                    Text(recommendation.confidenceText)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(recommendation.confidenceColor)
                    
                    Text("\(Int((recommendation.confidence ?? 0) * 100))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(recommendation.confidenceColor)
                }
            }
            .padding()
            
            // Recommendation details
            VStack(spacing: 12) {
                Text(recommendation.displayReasoning)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Expected Return")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(String(format: "%.1f", recommendation.displayExpectedReturn))%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 3) {
                        Text("Time to Goal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(recommendation.displayTimeToGoalText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("Investment")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(CurrencyFormatter.formatCompact(recommendation.displayExpectedReturn * 1000)) // Placeholder calculation
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            
            // Action buttons
            HStack(spacing: 10) {
                Button(action: onSelect) {
                    HStack {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        Text(isSelected ? "Selected" : "Compare")
                    }
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .green : .blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.green : Color.blue, lineWidth: 1)
                    )
                }
                
                Button(action: {
                    showDetail = true
                }) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Details")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .sheet(isPresented: $showDetail) {
            RecommendationDetailView(recommendation: recommendation)
                .environmentObject(GoalsViewModel())
        }
    }
}

struct PreferenceRow: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .primary
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

struct InvestmentPreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var investmentAmount: Double
    @Binding var riskTolerance: RiskLevel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Investment Amount") {
                    HStack {
                        Text("Total Amount to Invest")
                        Spacer()
                        TextField("Amount", value: $investmentAmount, format: .currency(code: "INR"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Text("This is the total amount you want to invest. AI will suggest how to distribute this across different stocks.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Risk Tolerance") {
                    Picker("Risk Level", selection: $riskTolerance) {
                        ForEach(RiskLevel.allCases, id: \.self) { level in
                            HStack {
                                Circle()
                                    .fill(level.color)
                                    .frame(width: 12, height: 12)
                                Text(level.rawValue)
                                Text("- \(level.description)")
                                    .foregroundColor(.secondary)
                            }
                            .tag(level)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How AI Will Help")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.blue)
                                Text("AI will analyze your goals and suggest optimal stock quantities")
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "clock")
                                    .foregroundColor(.green)
                                Text("Calculate exact time needed to reach your goals using compound interest")
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "target")
                                    .foregroundColor(.orange)
                                Text("Match stocks with your risk tolerance and investment amount")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Summary")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("• Total Investment: ₹\(CurrencyFormatter.formatCompact(investmentAmount))")
                            Text("• Risk Level: \(riskTolerance.rawValue)")
                            Text("• AI will suggest: Optimal shares and time to goal")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Investment Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    StockRecommendationsView()
        .environmentObject(GoalsViewModel())
} 
 