//
//  GoalDetailView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAddInvestment = false
    @State private var investmentAmount = ""
    @State private var animateProgress = false
    @State private var showConfetti = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header with goal info
                    GoalHeaderView(goal: goal)
                    
                    // Progress visualization
                    ProgressVisualizationView(goal: goal, animateProgress: animateProgress)
                    
                    // Investment tracking
                    InvestmentTrackingView(goal: goal)
                    
                    // Timeline view
                    TimelineView(goal: goal)
                    
                    // Action buttons
                                    GoalActionButtonsView(
                    goal: goal,
                    showAddInvestment: $showAddInvestment
                )
                }
                .padding()
            }
            .navigationTitle(goal.name)
            .navigationBarTitleDisplayMode(.large)
            .background(
                LinearGradient(
                    colors: [goal.category.color.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .sheet(isPresented: $showAddInvestment) {
                AddInvestmentView(
                    goal: goal,
                    investmentAmount: $investmentAmount
                )
                .environmentObject(viewModel)
            }
        }
        .onAppear {
            withAnimation(AnimationUtils.springAnimation.delay(0.3)) {
                animateProgress = true
            }
            
            if goal.isCompleted {
                showConfetti = true
            }
        }
    }
}

struct GoalHeaderView: View {
    let goal: Goal
    
    var body: some View {
        VStack(spacing: 20) {
            // Goal icon and category
            ZStack {
                Circle()
                    .fill(goal.category.gradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: goal.category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(goal.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(goal.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if goal.isCompleted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Goal Achieved!")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.top, 5)
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

struct ProgressVisualizationView: View {
    let goal: Goal
    let animateProgress: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Circular progress
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: animateProgress ? goal.progress : 0)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [goal.category.color, goal.category.color.opacity(0.7)]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(AnimationUtils.springAnimation.delay(0.5), value: animateProgress)
                
                VStack(spacing: 5) {
                    Text("\(Int(goal.progress * 100))%")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Amount details
            HStack(spacing: 30) {
                VStack {
                    Text(CurrencyFormatter.formatCompact(goal.currentAmount))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Invested")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text(CurrencyFormatter.formatCompact(goal.remainingAmount))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text(CurrencyFormatter.formatCompact(goal.targetAmount))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Target")
                        .font(.caption)
                        .foregroundColor(.secondary)
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

struct InvestmentTrackingView: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Investment Details")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                GoalDetailRow(
                    title: "Monthly Investment",
                    value: CurrencyFormatter.formatCompact(goal.monthlyInvestment),
                    icon: "arrow.up.circle.fill",
                    color: .orange
                )
                
                GoalDetailRow(
                    title: "Start Date",
                    value: DateUtils.formatDate(goal.startDate),
                    icon: "calendar",
                    color: .blue
                )
                
                GoalDetailRow(
                    title: "Target Date",
                    value: DateUtils.formatDate(goal.targetDate),
                    icon: "target",
                    color: .purple
                )
                
                GoalDetailRow(
                    title: "Days Remaining",
                    value: DateUtils.formatDaysRemaining(goal.daysRemaining),
                    icon: "clock",
                    color: goal.daysRemaining < 30 ? .red : .green
                )
                
                GoalDetailRow(
                    title: "Projected Amount",
                    value: CurrencyFormatter.formatCompact(goal.projectedAmount),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                )
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

struct GoalDetailRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct TimelineView: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Timeline")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 20) {
                TimelineItem(
                    date: goal.startDate,
                    title: "Started",
                    description: "Goal creation",
                    isCompleted: true,
                    color: .green
                )
                
                TimelineItem(
                    date: Date(),
                    title: "Current",
                    description: "\(Int(goal.progress * 100))% complete",
                    isCompleted: true,
                    color: .blue
                )
                
                TimelineItem(
                    date: goal.targetDate,
                    title: "Target",
                    description: "Goal deadline",
                    isCompleted: goal.isCompleted,
                    color: goal.isCompleted ? .green : .orange
                )
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

struct TimelineItem: View {
    let date: Date
    let title: String
    let description: String
    let isCompleted: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(DateUtils.formatDate(date))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct GoalActionButtonsView: View {
    let goal: Goal
    @Binding var showAddInvestment: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            if !goal.isCompleted {
                Button(action: {
                    showAddInvestment = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Investment")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(goal.category.gradient)
                    )
                }
            }
            
            Button(action: {
                // Share goal functionality
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Goal")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue, lineWidth: 2)
                )
            }
        }
    }
}

struct AddInvestmentView: View {
    let goal: Goal
    @Binding var investmentAmount: String
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(goal.category.gradient)
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    
                    Text("Add Investment")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Add money to your \(goal.name) goal")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Amount input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Investment Amount")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("₹")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        TextField("0", text: $investmentAmount)
                            .keyboardType(.numberPad)
                            .font(.title2)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
                
                // Quick amount buttons
                QuickAmountButtonsView(investmentAmount: $investmentAmount)
                
                Spacer()
                
                // Add button
                Button(action: addInvestment) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Investment")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isFormValid ? goal.category.color : Color.gray)
                    )
                }
                .disabled(!isFormValid)
            }
            .padding()
            .navigationTitle("Add Investment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Investment Added!", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("₹\(investmentAmount) has been added to your goal.")
            }
        }
    }
    
    private var isFormValid: Bool {
        !investmentAmount.isEmpty && Double(investmentAmount) ?? 0 > 0
    }
    
    private func addInvestment() {
        guard isFormValid else { return }
        
        let amount = Double(investmentAmount) ?? 0
        viewModel.addInvestment(to: goal, amount: amount)
        showSuccess = true
    }
}

struct QuickAmountButtonsView: View {
    @Binding var investmentAmount: String
    
    let quickAmounts = ["1000", "2000", "5000", "10000"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Amounts")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(quickAmounts, id: \.self) { amount in
                    Button(action: {
                        investmentAmount = amount
                    }) {
                        Text("₹\(amount)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    GoalDetailView(goal: Goal(
        name: "Dream Bike",
        targetAmount: 150000,
        currentAmount: 45000,
        monthlyInvestment: 5000,
        startDate: Date().addingTimeInterval(-90 * 24 * 60 * 60),
        targetDate: Date().addingTimeInterval(120 * 24 * 60 * 60),
        category: .vehicle
    ))
    .environmentObject(GoalsViewModel())
} 