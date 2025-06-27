//
//  LatteActionIntent.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

struct LatteActionIntent : AppIntent {
    static let title: LocalizedStringResource = "Latte Order Update"
    static let isDiscoverable: Bool = false
    init () {
        
    }
    init (isUpdatingPercentage : Bool, isIncremental : Bool) {
        self.isIncremental = isIncremental
        self.isUpdatingPercentage = isUpdatingPercentage
    }
    
    @Parameter var isUpdatingPercentage : Bool
    @Parameter var isIncremental: Bool
    
    @Dependency var manager : LatteOrderManager
    
    func perform() async throws -> some IntentResult {
        if isUpdatingPercentage {
           if isIncremental {
                manager.milkPercentage = min(manager.milkPercentage + 10, 100)
            }
            else {
                manager.milkPercentage = max(manager.milkPercentage - 10, 0)
            }
        }
        else {
            if isIncremental {
                 manager.count = min(manager.count + 1, 10)
             }
             else {
                 manager.count = max(manager.count - 1, 1)
             }
        }
        return .result()
    }
    
}
