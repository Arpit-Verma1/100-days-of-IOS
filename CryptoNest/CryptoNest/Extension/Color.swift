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
static  let lauch = LaunchTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
