//
//  Colors.swift
//  retroCar
//
//  Created by Arpit Verma on 1/18/26.
//

import Foundation
import SwiftUI


extension Color {
    
    static let theme = ColorTheme()
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8) & 0xFF) / 255
        let blue = Double(rgb & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

struct ColorTheme {
    public static let dividerColor = Color("DividerColor")
    
    // Text
    let textColor = Color("TextColor")
    let ntextColor = Color("NTextColor")
    let subTitleTexColor = Color("SubTitleTextColor")
    let highlightColor = Color("HighLightColor")
    
    
    // Buttons
    let primaryButtonColor = Color("PrimaryButtonColor")
    let secondaryButtonColor = Color("SecondaryButtonColor")
    
    // Gradients
    let onboardingStart = Color("OnboardingBackgroudStart")
    let onboardingEnd = Color("OnboardingBackgroudEnd")
    let homeBackgroundStart = Color("HomeBackgroundStart")
    let homeBackgroundEnd = Color("HomeBackgroundEnd")
    
    // Home gradient color stops
    let homeGradient1 = Color("HomeGradient1")
    let homeGradient2 = Color("HomeGradient2")
    let homeGradient3 = Color("HomeGradient3")
    let homeGradient4 = Color("HomeGradient4")
    
    // Card
    let cardColor = Color("CardColor")
    
    // BMI Colors
    let bmiUnderweight = Color(hex: "6699FF") // Blue
    let bmiHealthy = Color(hex: "4CAF50") // Green
    let bmiOverweight = Color(hex: "FF9800") // Orange
    let bmiObese = Color(hex: "F44336") // Red
    let secondaryText = Color(white: 0.6)

    // Tab bar
    let tabBarBackground = Color(hex: "EB4F6B")
    let tabBarSelected = Color.white
    let tabBarUnselected = Color(hex: "9E9E9E")

    // Home / promo
    let homePromoBackground = Color(hex: "FFE4EC")

    // Add Cart button (black)
    let addCartButtonBackground = Color.black

    // Order complete / flower detail
    let orderCompleteBorder = Color(hex: "EBF5EC")
    let trackOrderButtonBackground = Color(hex: "4CAF50")

    // Cart / Basket (empty state button)
    let startShoppingButtonBackground = Color(hex: "82C982")

    let borderColor = Color("BorderColor")
}

@MainActor
public extension LinearGradient {
    
    static var homeViewBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color.theme.homeGradient1,
                Color.theme.homeGradient2,
                Color.theme.homeGradient3,
                Color.theme.homeGradient4
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    static var onBoardinBackground : LinearGradient {
        LinearGradient(colors: [Color.theme.onboardingStart, Color.theme.onboardingEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    
}
