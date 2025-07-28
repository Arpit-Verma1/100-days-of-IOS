//
//  GoalsListView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var selectedFilter: GoalFilter = .all
    @State private var animateCards = false
    
    enum GoalFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
    }
    
    var filteredGoals: [Goal] {
        switch selectedFilter {
        case .all:
            return viewModel.goals
        case .active:
            return viewModel.goals.filter { !$0.isCompleted }
        case .completed:
            return viewModel.goals.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                
                // Filter buttons
                FilterButtonsView(selectedFilter: $selectedFilter)
                
                if filteredGoals.isEmpty {
                    GoalsEmptyStateView(filter: selectedFilter)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(filteredGoals.enumerated()), id: \.element.id) { index, goal in
                                GoalCardView(goal: goal)
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
                }
            }
            .navigationTitle("My Goals")
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
            // Force load sample data if empty
            if viewModel.goals.isEmpty {
                viewModel.loadSampleData()
            }
            
            withAnimation(AnimationUtils.springAnimation.delay(0.3)) {
                animateCards = true
            }
        }
    }
}

struct FilterButtonsView: View {
    @Binding var selectedFilter: GoalsListView.GoalFilter
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(GoalsListView.GoalFilter.allCases, id: \.self) { filter in
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
        .padding(.vertical, 10)
    }
}


struct GoalCardView: View {
    let goal: Goal
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var showDetail = false
    @State private var animateProgress = false
    @State private var showConfetti = false
    
    var body: some View {
        Button(action: {
            viewModel.selectedGoal = goal
            showDetail = true
        }) {
            VStack(spacing: 0) {
                // Header with icon and category
                HStack {
                    ZStack {
                        Circle()
                            .fill(goal.category.gradient)
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateProgress ? 1.1 : 1.0)
                            .animation(AnimationUtils.pulseAnimation(), value: animateProgress)
                        
                        Image(systemName: goal.category.icon)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(goal.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(goal.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(DateUtils.formatDaysRemaining(goal.daysRemaining))")
                            .font(.caption)
                            .foregroundColor(goal.daysRemaining < 30 ? .red : .secondary)
                    }
                    
                    Spacer()
                    
                    if goal.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                            .scaleEffect(showConfetti ? 1.2 : 1.0)
                            .animation(AnimationUtils.bounceAnimation, value: showConfetti)
                    }
                }
                .padding()
                
                // Progress section
                VStack(spacing: 15) {
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 12)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(goal.category.gradient)
                                .frame(width: geometry.size.width * (animateProgress ? goal.progress : 0), height: 12)
                                .animation(AnimationUtils.springAnimation.delay(0.5), value: animateProgress)
                        }
                    }
                    .frame(height: 12)
                    
                    // Amount details
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Current")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(CurrencyFormatter.formatCompact(goal.currentAmount))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 5) {
                            Text("Progress")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(Int(goal.progress * 100))%")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("Target")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(CurrencyFormatter.formatCompact(goal.targetAmount))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Monthly investment info
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.orange)
                        Text("Monthly: \(CurrencyFormatter.formatCompact(goal.monthlyInvestment))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .sheet(isPresented: $showDetail) {
            GoalDetailView(goal: goal)
                .environmentObject(viewModel)
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

struct GoalsEmptyStateView: View {
    let filter: GoalsListView.GoalFilter
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: emptyStateIcon)
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(emptyStateTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(emptyStateMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var emptyStateIcon: String {
        switch filter {
        case .all:
            return "target"
        case .active:
            return "plus.circle"
        case .completed:
            return "checkmark.circle"
        }
    }
    
    private var emptyStateTitle: String {
        switch filter {
        case .all:
            return "No Goals Yet"
        case .active:
            return "No Active Goals"
        case .completed:
            return "No Completed Goals"
        }
    }
    
    private var emptyStateMessage: String {
        switch filter {
        case .all:
            return "Start your investment journey by creating your first goal!"
        case .active:
            return "All your goals are completed! Time to set new ones."
        case .completed:
            return "Complete some goals to see them here."
        }
    }
}

#Preview {
    GoalsListView()
        .environmentObject(GoalsViewModel())
} 
 
