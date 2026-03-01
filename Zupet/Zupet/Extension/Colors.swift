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
    

    let borderColor = Color("BorderColor")
    let secondaryText = Color(white: 0.6)
    
    let petStripe1 = Color(hex: "#d6c0de")
    let petStripe2 = Color(hex: "#feb447")
    let petStripe3 = Color(hex: "#fbbabe")
    let petStripe4 = Color(hex: "#bfe3e6")
    
    let backgroundColor = Color("BackgroundColor")
    let buttonTextColor = Color(hex:"#ffdaa3")
                           
}

@MainActor
public extension LinearGradient {
    
    
    
}
