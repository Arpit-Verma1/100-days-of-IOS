//
//  Goal.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import Foundation
import SwiftUI

struct Goal: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var monthlyInvestment: Double
    var startDate: Date
    var targetDate: Date
    var category: GoalCategory
    var isCompleted: Bool = false
    
    var progress: Double {
        return min(currentAmount / targetAmount, 1.0)
    }
    
    var remainingAmount: Double {
        return max(targetAmount - currentAmount, 0)
    }
    
    var daysRemaining: Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day ?? 0
    }
    
    var projectedAmount: Double {
        let monthsRemaining = Double(daysRemaining) / 30.0
        let futureInvestments = monthlyInvestment * monthsRemaining
        return currentAmount + futureInvestments
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
}

enum GoalCategory: String, CaseIterable, Codable {
    case travel = "Travel"
    case vehicle = "Vehicle"
    case house = "House"
    case education = "Education"
    case gadget = "Gadget"
    case wedding = "Wedding"
    case business = "Business"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .travel: return "airplane"
        case .vehicle: return "car.fill"
        case .house: return "house.fill"
        case .education: return "book.fill"
        case .gadget: return "laptopcomputer"
        case .wedding: return "heart.fill"
        case .business: return "briefcase.fill"
        case .other: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .travel: return .blue
        case .vehicle: return .green
        case .house: return .orange
        case .education: return .purple
        case .gadget: return .gray
        case .wedding: return .pink
        case .business: return .indigo
        case .other: return .yellow
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .travel: return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .vehicle: return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .house: return LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .education: return LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .gadget: return LinearGradient(colors: [.gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .wedding: return LinearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .business: return LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .other: return LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
} 