//
//  ProfileView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @State private var animateStats = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Profile header
                    ProfileHeaderView()
                    
                    // Statistics overview
                    StatisticsOverviewView(animateStats: animateStats)
                    
                    // Achievement badges
                    AchievementBadgesView()
                    
                    // Settings options
                    SettingsOptionsView()
                    
                    // App info
                    AppInfoView()
                }
                .padding()
            }
            .navigationTitle("Profile")
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
                animateStats = true
            }
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Profile image
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
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Investment Champion")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Building wealth, one goal at a time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
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

struct StatisticsOverviewView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    let animateStats: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Statistics")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                StatisticCard(
                    title: "Total Invested",
                    value: CurrencyFormatter.formatCompact(viewModel.getTotalInvested()),
                    icon: "banknote.fill",
                    color: .green,
                    animate: animateStats
                )
                
                StatisticCard(
                    title: "Goals Created",
                    value: "\(viewModel.goals.count)",
                    icon: "target",
                    color: .blue,
                    animate: animateStats
                )
                
                StatisticCard(
                    title: "Goals Completed",
                    value: "\(viewModel.goals.filter { $0.isCompleted }.count)",
                    icon: "checkmark.circle.fill",
                    color: .orange,
                    animate: animateStats
                )
                
                StatisticCard(
                    title: "Success Rate",
                    value: "\(Int((Double(viewModel.goals.filter { $0.isCompleted }.count) / Double(max(viewModel.goals.count, 1))) * 100))%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .purple,
                    animate: animateStats
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

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animate: Bool
    @State private var animateValue = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(AnimationUtils.pulseAnimation(), value: animate)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .opacity(animateValue ? 1 : 0)
                .animation(AnimationUtils.springAnimation.delay(0.5), value: animateValue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .onAppear {
            if animate {
                animateValue = true
            }
        }
    }
}

struct AchievementBadgesView: View {
    let achievements = [
        Achievement(title: "First Goal", description: "Created your first goal", icon: "star.fill", color: .yellow, isUnlocked: true),
        Achievement(title: "Goal Setter", description: "Created 5 goals", icon: "target", color: .blue, isUnlocked: true),
        Achievement(title: "Goal Achiever", description: "Completed your first goal", icon: "checkmark.circle.fill", color: .green, isUnlocked: true),
        Achievement(title: "Investment Pro", description: "Invested ₹1,00,000", icon: "banknote.fill", color: .purple, isUnlocked: false),
        Achievement(title: "Consistent Saver", description: "Invested for 6 months", icon: "calendar", color: .orange, isUnlocked: false),
        Achievement(title: "Goal Master", description: "Completed 10 goals", icon: "crown.fill", color: .red, isUnlocked: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                ForEach(achievements, id: \.title) { achievement in
                    AchievementBadge(achievement: achievement)
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

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

struct AchievementBadge: View {
    let achievement: Achievement
    @State private var showDetails = false
    
    var body: some View {
        Button(action: {
            showDetails = true
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.color : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: achievement.icon)
                        .font(.title3)
                        .foregroundColor(achievement.isUnlocked ? .white : .gray)
                }
                
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .alert(achievement.title, isPresented: $showDetails) {
            Button("OK") { }
        } message: {
            Text(achievement.description)
        }
    }
}

struct SettingsOptionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                SettingsRow(
                    title: "Notifications",
                    subtitle: "Manage goal reminders",
                    icon: "bell.fill",
                    color: .blue
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    title: "Export Data",
                    subtitle: "Download your goal data",
                    icon: "square.and.arrow.up",
                    color: .green
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    title: "Privacy",
                    subtitle: "Manage your privacy settings",
                    icon: "lock.fill",
                    color: .orange
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    title: "Help & Support",
                    subtitle: "Get help and contact support",
                    icon: "questionmark.circle.fill",
                    color: .purple
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Handle settings action
        }) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 25)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct AppInfoView: View {
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 8) {
                Text("SIP Goal Visualizer")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Transform your dreams into reality with smart SIP goal tracking")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            HStack(spacing: 20) {
                SocialButton(title: "Rate App", icon: "star.fill", color: .yellow)
                SocialButton(title: "Share", icon: "square.and.arrow.up", color: .blue)
                SocialButton(title: "Feedback", icon: "envelope.fill", color: .green)
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

struct SocialButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Handle social action
        }) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(GoalsViewModel())
} 