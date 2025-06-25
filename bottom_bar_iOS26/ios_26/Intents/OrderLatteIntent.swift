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
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

