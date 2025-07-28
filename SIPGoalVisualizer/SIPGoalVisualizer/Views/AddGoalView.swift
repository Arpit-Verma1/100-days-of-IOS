//
//  AddGoalView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import SwiftUI

struct AddGoalView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var goalName = ""
    @State private var targetAmount = ""
    @State private var monthlyInvestment = ""
    @State private var selectedCategory: GoalCategory = .travel
    @State private var targetDate = Date().addingTimeInterval(365 * 24 * 60 * 60)
    @State private var currentAmount = ""
    @State private var showCategoryPicker = false
    @State private var animateForm = false
    @State private var showSuccess = false
    @State private var isResetting = false
    @State private var showResetMessage = false
    @State private var showResetConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    HeaderView()
                        .scaleEffect(isResetting ? 0.95 : 1.0)
                        .opacity(isResetting ? 0.7 : 1.0)
                    
                    // Goal name
                    InputField(
                        title: "Goal Name",
                        placeholder: "e.g., Dream Bike, Europe Trip",
                        text: $goalName,
                        icon: "pencil"
                    )
                    .scaleEffect(isResetting ? 0.98 : 1.0)
                    .opacity(isResetting ? 0.8 : 1.0)
                    
                    // Category selection
                    CategorySelectionView(
                        selectedCategory: $selectedCategory,
                        showPicker: $showCategoryPicker
                    )
                    
                    // Amount fields
                    VStack(spacing: 20) {
                        InputField(
                            title: "Target Amount",
                            placeholder: "₹1,00,000",
                            text: $targetAmount,
                            icon: "target",
                            keyboardType: .numberPad
                        )
                        
                        InputField(
                            title: "Current Amount (Optional)",
                            placeholder: "₹0",
                            text: $currentAmount,
                            icon: "banknote",
                            keyboardType: .numberPad
                        )
                        
                        InputField(
                            title: "Monthly Investment",
                            placeholder: "₹5,000",
                            text: $monthlyInvestment,
                            icon: "arrow.up.circle",
                            keyboardType: .numberPad
                        )
                    }
                    
                    // Target date
                    DateSelectionView(targetDate: $targetDate)
                    
                    // Summary card
                    SummaryCardView(
                        goalName: goalName,
                        targetAmount: targetAmount,
                        monthlyInvestment: monthlyInvestment,
                        selectedCategory: selectedCategory,
                        targetDate: targetDate
                    )
                    
                    // Create button
                    CreateButtonView(
                        isFormValid: isFormValid,
                        action: createGoal
                    )
                }
                .padding()
            }
            .navigationTitle("Create Goal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        showResetConfirmation = true
                    }
                    .disabled(goalName.isEmpty && targetAmount.isEmpty && monthlyInvestment.isEmpty)
                }
            }
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .sheet(isPresented: $showCategoryPicker) {
                CategoryPickerView(selectedCategory: $selectedCategory)
            }
            .alert("Goal Created!", isPresented: $showSuccess) {
                Button("Create Another") {
                    // Form is already cleared, just hide the alert
                }
                Button("Done") {
                    dismiss()
                }
            } message: {
                Text("Your goal has been created successfully! Would you like to create another goal?")
            }
            .confirmationDialog("Reset Form", isPresented: $showResetConfirmation) {
                Button("Clear All Fields", role: .destructive) {
                    clearForm()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will clear all the fields. Are you sure you want to reset the form?")
            }
        }
                    .onAppear {
                withAnimation(AnimationUtils.springAnimation.delay(0.3)) {
                    animateForm = true
                }
            }
            .overlay(
                Group {
                    if showResetMessage {
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Form cleared successfully!")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            Spacer().frame(height: 100)
                        }
                        .animation(.easeInOut(duration: 0.3), value: showResetMessage)
                    }
                }
            )
    }
    
    private var isFormValid: Bool {
        !goalName.isEmpty &&
        !targetAmount.isEmpty &&
        !monthlyInvestment.isEmpty &&
        Double(targetAmount) ?? 0 > 0 &&
        Double(monthlyInvestment) ?? 0 > 0
    }
    
    private func createGoal() {
        guard isFormValid else { return }
        
        let goal = Goal(
            name: goalName,
            targetAmount: Double(targetAmount) ?? 0,
            currentAmount: Double(currentAmount) ?? 0,
            monthlyInvestment: Double(monthlyInvestment) ?? 0,
            startDate: Date(),
            targetDate: targetDate,
            category: selectedCategory
        )
        
        viewModel.addGoal(goal)
        clearForm()
        showSuccess = true
    }
    
    private func clearForm() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isResetting = true
        }
        
        goalName = ""
        targetAmount = ""
        monthlyInvestment = ""
        currentAmount = ""
        selectedCategory = .travel
        targetDate = Date().addingTimeInterval(365 * 24 * 60 * 60)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isResetting = false
            }
            
            // Show reset message
            showResetMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showResetMessage = false
            }
        }
    }
}

struct HeaderView: View {
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
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text("Create Your Goal")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Set a financial goal and start your investment journey")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: GoalCategory
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.headline)
                .fontWeight(.semibold)
            
            Button(action: {
                showPicker = true
            }) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(selectedCategory.gradient)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: selectedCategory.icon)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    Text(selectedCategory.rawValue)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
        }
    }
}

struct DateSelectionView: View {
    @Binding var targetDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Target Date")
                .font(.headline)
                .fontWeight(.semibold)
            
            DatePicker(
                "Target Date",
                selection: $targetDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

struct SummaryCardView: View {
    let goalName: String
    let targetAmount: String
    let monthlyInvestment: String
    let selectedCategory: GoalCategory
    let targetDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Goal Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                SummaryRow(title: "Goal", value: goalName.isEmpty ? "Not set" : goalName)
                SummaryRow(title: "Category", value: selectedCategory.rawValue)
                SummaryRow(title: "Target Amount", value: targetAmount.isEmpty ? "Not set" : "₹\(targetAmount)")
                SummaryRow(title: "Monthly Investment", value: monthlyInvestment.isEmpty ? "Not set" : "₹\(monthlyInvestment)")
                SummaryRow(title: "Target Date", value: DateUtils.formatDate(targetDate))
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


struct CreateButtonView: View {
    let isFormValid: Bool
    let action: () -> Void
    @State private var animateButton = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Create Goal")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isFormValid ? Color.blue : Color.gray)
            )
        }
        .disabled(!isFormValid)
        .scaleEffect(animateButton ? 1.05 : 1.0)
        .animation(AnimationUtils.pulseAnimation(), value: animateButton)
        .onAppear {
            animateButton = true
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: GoalCategory
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(GoalCategory.allCases, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                    dismiss()
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(category.gradient)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: category.icon)
                                .foregroundColor(.white)
                        }
                        
                        Text(category.rawValue)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddGoalView()
        .environmentObject(GoalsViewModel())
} 
 