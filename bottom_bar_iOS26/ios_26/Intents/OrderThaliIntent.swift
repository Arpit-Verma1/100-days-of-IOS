//
//  OrderThaliIntent.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

enum ThaliOrderPage: String {
    case page1 = "Selecting Main Course"
    case page2 = "Choosing Bread Type"
    case page3 = "Adjusting Rice Quantity"
    case page4 = "Adding Side Dishes"
    case page5 = "Order Complete"
}

struct OrderThaliIntent: AppIntent {
    static let title: LocalizedStringResource = "Order Thali Combo"
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let manager = ThaliComboManager.shared
        
        // Step 1: Select main course
        manager.mainCourse = try await requestChoice(between: Self.mainCourseChoices, dialog: .init("Select Main Course")).title
        try await requestConfirmation(actionName: .set, snippetIntent: MainCourseConfirmationContent())
        
        // Step 2: Choose bread type
        manager.breadType = try await requestChoice(between: Self.breadChoices, dialog: .init("Select Bread Type")).title
        try await requestConfirmation(actionName: .set, snippetIntent: BreadTypeConfirmationContent())
        
        // Step 3: Adjust rice quantity
        try await requestConfirmation(actionName: .set, snippetIntent: RiceQuantityContent())
        
        // Step 4: Add side dishes
        try await requestConfirmation(actionName: .set, snippetIntent: SideDishesContent())
        
        // Complete order
        try await manager.orderThali()
        return .result(view: ThaliComboView(
            mainCourse: manager.mainCourse,
            breadType: manager.breadType,
            riceQuantity: manager.riceQuantity,
            sideDishes: manager.sideDishes,
            page: .page5
        ).padding(.horizontal, 10))
    }
    
    static var mainCourseChoices: [IntentChoiceOption] {
        [
            .init(title: "Butter Chicken", style: .default),
            .init(title: "Paneer Tikka"),
            .init(title: "Dal Makhani"),
            .init(title: "Chicken Tikka"),
            .init(title: "Mixed Vegetables")
        ]
    }
    
    static var breadChoices: [IntentChoiceOption] {
        [
            .init(title: "Naan", style: .default),
            .init(title: "Roti"),
            .init(title: "Paratha"),
            .init(title: "Kulcha"),
            .init(title: "Bhatura")
        ]
    }
}

struct MainCourseConfirmationContent: SnippetIntent {
    static let title: LocalizedStringResource = "Main Course Selection"
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let manager = ThaliComboManager.shared
        return .result(view: ThaliComboView(
            mainCourse: manager.mainCourse,
            breadType: manager.breadType,
            riceQuantity: manager.riceQuantity,
            sideDishes: manager.sideDishes,
            page: .page1
        ))
    }
}

struct BreadTypeConfirmationContent: SnippetIntent {
    static let title: LocalizedStringResource = "Bread Type Selection"
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let manager = ThaliComboManager.shared
        return .result(view: ThaliComboView(
            mainCourse: manager.mainCourse,
            breadType: manager.breadType,
            riceQuantity: manager.riceQuantity,
            sideDishes: manager.sideDishes,
            page: .page2
        ))
    }
}

struct RiceQuantityContent: SnippetIntent {
    static let title: LocalizedStringResource = "Rice Quantity"
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let manager = ThaliComboManager.shared
        return .result(view: ThaliComboView(
            mainCourse: manager.mainCourse,
            breadType: manager.breadType,
            riceQuantity: manager.riceQuantity,
            sideDishes: manager.sideDishes,
            page: .page3
        ))
    }
}

struct SideDishesContent: SnippetIntent {
    static let title: LocalizedStringResource = "Side Dishes"
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let manager = ThaliComboManager.shared
        return .result(view: ThaliComboView(
            mainCourse: manager.mainCourse,
            breadType: manager.breadType,
            riceQuantity: manager.riceQuantity,
            sideDishes: manager.sideDishes,
            page: .page4
        ))
    }
} 