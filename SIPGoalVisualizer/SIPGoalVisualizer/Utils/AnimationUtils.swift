//
//  AnimationUtils.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import SwiftUI

struct AnimationUtils {
    static let springAnimation = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let easeInOutAnimation = Animation.easeInOut(duration: 0.3)
    static let bounceAnimation = Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
    
    static func pulseAnimation() -> Animation {
        return Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    }
    
    static func scaleAnimation() -> Animation {
        return Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)
    }
}

struct CurrencyFormatter {
    static func format(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "₹0"
    }
    
    static func formatCompact(_ amount: Double) -> String {
        if amount >= 100000 {
            return String(format: "₹%.1fL", amount / 100000)
        } else if amount >= 1000 {
            return String(format: "₹%.1fK", amount / 1000)
        } else {
            return String(format: "₹%.0f", amount)
        }
    }
}

struct DateUtils {
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    static func formatDaysRemaining(_ days: Int) -> String {
        if days == 0 {
            return "Today!"
        } else if days == 1 {
            return "1 day left"
        } else if days < 0 {
            return "Overdue"
        } else {
            return "\(days) days left"
        }
    }
}

struct ColorUtils {
    static func progressColor(for progress: Double) -> Color {
        if progress >= 0.8 {
            return .green
        } else if progress >= 0.5 {
            return .orange
        } else {
            return .red
        }
    }
    
    static func progressGradient(for progress: Double) -> LinearGradient {
        let color = progressColor(for: progress)
        return LinearGradient(
            colors: [color.opacity(0.7), color],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
} 
 