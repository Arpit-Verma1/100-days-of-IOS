//
//  ThaliActionIntent.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

struct ThaliActionIntent: AppIntent {
    static let title: LocalizedStringResource = "Thali Combo Update"
    static let isDiscoverable: Bool = false
    
    init() {
        
    }
    
    init(isUpdatingRice: Bool, isIncremental: Bool, sideDish: String? = nil) {
        self.isUpdatingRice = isUpdatingRice
        self.isIncremental = isIncremental
        self.sideDish = sideDish
    }
    
    @Parameter var isUpdatingRice: Bool
    @Parameter var isIncremental: Bool
    @Parameter var sideDish: String?
    
    func perform() async throws -> some IntentResult {
        let manager = ThaliComboManager.shared
        
        if isUpdatingRice {
            if isIncremental {
                manager.riceQuantity = min(manager.riceQuantity + 1, 5)
            } else {
                manager.riceQuantity = max(manager.riceQuantity - 1, 1)
            }
        } else {
            // Handle side dishes
            if let dish = sideDish {
                if isIncremental {
                    if !manager.sideDishes.contains(dish) {
                        manager.sideDishes.append(dish)
                    }
                } else {
                    manager.sideDishes.removeAll { $0 == dish }
                }
            }
        }
        return .result()
    }
} 
 