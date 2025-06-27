//
//  OrderLatteIntent.swift
//  ios_26
//
//  Created by Arpit Verma on 6/25/25.
//

import SwiftUI
import AppIntents


struct OrderLatteIntent: AppIntent{
    static let title : LocalizedStringResource = "Order Latter"
    @Dependency var manager : LatteOrderManager
    
    func perform() async throws -> some IntentResult  & ShowsSnippetView {
        manager.choice = try await requestChoice(between: Self.choices, dialog: .init("Select Size")).title
        try await  requestConfirmation(actionName: .set,snippetIntent: MilkPercentageContfirmationContent())
        
        
        try await  requestConfirmation(actionName: .order,snippetIntent: LatteCountContent())
        
        try await manager.orderLatte()
        return .result(view: LatteOrderView(count: manager.count, milkPercentage: manager.milkPercentage, page: .page3, choice: manager.choice).padding(.horizontal, 10))
        
    }
    
    static var choices : [IntentChoiceOption] {
        [
            .init(title: "Small", style: .default),
            .init(title: "Medium"),
            .init(title: "Large")
            
        ]
    }
 }

struct MilkPercentageContfirmationContent : SnippetIntent {
    static let title : LocalizedStringResource  = "Milk Percentage in Latte"
    @Dependency var manager : LatteOrderManager
    func perform() async throws -> some IntentResult  & ShowsSnippetView{
        return .result(view: LatteOrderView(count: manager.count,milkPercentage: manager.milkPercentage, page: .page1, choice: manager.choice))
    }
    
}

struct LatteCountContent : SnippetIntent {
    static let title : LocalizedStringResource  = "Latte Count"
    @Dependency var manager : LatteOrderManager
    func perform() async throws -> some IntentResult  & ShowsSnippetView{
        return .result(view: LatteOrderView(count: manager.count,milkPercentage: manager.milkPercentage, page: .page2, choice: manager.choice))
    }
    
}

