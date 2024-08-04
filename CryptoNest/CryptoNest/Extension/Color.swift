//
//  Color.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import Foundation
import  SwiftUI


extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
