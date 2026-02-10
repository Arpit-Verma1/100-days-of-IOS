//
//  Fonts.swift
//  Intake
//
//  Created by Arpit Verma on 17/01/26.
//

import SwiftUI

// MARK: - Global Font Configuration
enum FontFamily: String, CaseIterable {
    case jenriv = "JenrivTitling-Bold"
    case kg = "KGAlwaysAGoodTime"

    var fontName: String {
        switch self {
        case .jenriv:
            return "JenrivTitling-Bold"
        case .kg:
            return "KGAlwaysAGoodTime"
        }
    }

    /// When true, typography uses system font; when false, uses custom font (fontName).
    var isSystemFont: Bool {
        return false
    }
}

// MARK: - Global Font Family Setting

let currentFontFamily: FontFamily = .jenriv

// MARK: - Font System
extension Font {
    static let typography = TypographySystem()
}

struct TypographySystem {
    
    // MARK: - Font Weights
    enum FontWeight: String, CaseIterable {
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case semibold = "SemiBold"
        case bold = "Bold"
        case heavy = "Heavy"
        
        var systemWeight: Font.Weight {
            switch self {
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            }
        }
    }
    
    // MARK: - Font Sizes
    enum FontSize: CGFloat, CaseIterable {
        case caption2 = 10
        case caption = 12
        case footnote = 13
        case subheadline = 14
        case callout = 16
        case body = 15
        case headline = 18
        case title3 = 20
        case title2 = 22
        case title1 = 28
        case largeTitle = 32
        case display = 48
        case hero = 64
    }
    
    // MARK: - Core Font Method
    private func font(weight: FontWeight, size: FontSize) -> Font {
        if currentFontFamily.isSystemFont {
            
            return Font.system(size: size.rawValue, weight: weight.systemWeight, design: .default)
        } else {
            return Font.custom(currentFontFamily.fontName, size: size.rawValue)
        }
    }
    
    // MARK: - Universal Font Methods (Works with any font family)
    
    // Caption Fonts
    public var caption2: Font { font(weight: .regular, size: .caption2) }
    public var caption2Medium: Font { font(weight: .medium, size: .caption2) }
    public var caption2Bold: Font { font(weight: .bold, size: .caption2) }
    public var caption: Font { font(weight: .regular, size: .caption) }
    public var captionMedium: Font { font(weight: .medium, size: .caption) }
    public var captionBold: Font { font(weight: .bold, size: .caption) }
    
    // Footnote Fonts
    public var footnote: Font { font(weight: .regular, size: .footnote) }
    public var footnoteMedium: Font { font(weight: .medium, size: .footnote) }
    public var footnoteBold: Font { font(weight: .bold, size: .footnote) }
    
    // Subheadline Fonts
    public var subheadline: Font { font(weight: .regular, size: .subheadline) }
    public var subheadlineMedium: Font { font(weight: .medium, size: .subheadline) }
    public var subheadlineBold: Font { font(weight: .bold, size: .subheadline) }
    
    // Callout Fonts
    public var callout: Font { font(weight: .regular, size: .callout) }
    public var calloutMedium: Font { font(weight: .medium, size: .callout) }
    public var calloutBold: Font { font(weight: .bold, size: .callout) }
    
    // Body Fonts
    public var body: Font { font(weight: .regular, size: .body) }
    public var bodyMedium: Font { font(weight: .medium, size: .body) }
    public var bodyBold: Font { font(weight: .bold, size: .body) }
    
    // Headline Fonts
    public var headline: Font { font(weight: .semibold, size: .headline) }
    public var headlineBold: Font { font(weight: .bold, size: .headline) }
    
    // Title Fonts
    public var title3: Font { font(weight: .regular, size: .title3) }
    public var title3Medium: Font { font(weight: .medium, size: .title3) }
    public var title3Bold: Font { font(weight: .bold, size: .title3) }
    
    public var title2: Font { font(weight: .regular, size: .title2) }
    public var title2Medium: Font { font(weight: .medium, size: .title2) }
    public var title2Bold: Font { font(weight: .bold, size: .title2) }
    
    public var title1: Font { font(weight: .regular, size: .title1) }
    public var title1Medium: Font { font(weight: .medium, size: .title1) }
    public var title1Bold: Font { font(weight: .bold, size: .title1) }
    
    // Large Title Fonts
    public var largeTitle: Font { font(weight: .regular, size: .largeTitle) }
    public var largeTitleMedium: Font { font(weight: .medium, size: .largeTitle) }
    public var largeTitleBold: Font { font(weight: .bold, size: .largeTitle) }
    
    // Display Fonts
    public var display: Font { font(weight: .regular, size: .display) }
    public var displayMedium: Font { font(weight: .medium, size: .display) }
    public var displayBold: Font { font(weight: .bold, size: .display) }
    
    // Hero Fonts
    public var hero: Font { font(weight: .light, size: .hero) }
    public var heroMedium: Font { font(weight: .medium, size: .hero) }
    public var heroBold: Font { font(weight: .bold, size: .hero) }
}


// MARK: - Font Style Presets for Specific UI Components

public struct FontStyle {
    public let font: Font
    public let lineSpacing: CGFloat
    public let letterSpacing: CGFloat?
    
    public init(font: Font, lineSpacing: CGFloat = 0, letterSpacing: CGFloat? = nil) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
    }
}
