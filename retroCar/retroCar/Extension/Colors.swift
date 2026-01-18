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
    // Separators
    public static let dividerColor = Color("DividerColor")
    
    // Text
    let textColor = Color("TextColor")
    let ntextColor = Color("NTextColor")
    let subTitleTexColor = Color("SubTitleTextColor")
    
    
    // Buttons
    let primaryButtonColor = Color("PrimaryButtonColor")
    let secondaryButtonColor = Color("SecondaryButtonColor")
    
    // Gradients
    let onboardingStart = Color("OnboardingStart")
    let onboardingEnd = Color("OnboardingEnd")
    let homeBackgroundStart = Color("HomeBackgroundStart")
    let homeBackgroundEnd = Color("HomeBackgroundEnd")
    
    // Card
    let cardColor1 = Color("CardColor1")
    let cardColor2 = Color("CardColor2")
    let cardColor3 = Color("CardColor3")
    let cardColor4 = Color("CardColor4")
    
    // Background
    let backgrounColor = Color("BackgroundColor")
    

}
