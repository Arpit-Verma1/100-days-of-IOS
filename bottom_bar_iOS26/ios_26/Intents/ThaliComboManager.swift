//
//  ThaliComboManager.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

// Marked as @unchecked Sendable because it is used in a context requiring Sendable and does not contain concurrency-sensitive state.
final class ThaliComboManager: @unchecked Sendable {
    static let shared = ThaliComboManager()
    
    var mainCourse: LocalizedStringResource = ""
    var breadType: LocalizedStringResource = ""
    var riceQuantity: Int = 1
    var sideDishes: [String] = []
    
    private init() {}
    
    func orderThali() async throws {
        try? await Task.sleep(for: .seconds(1))
    }
    
    static func registerDependency() {
        AppDependencyManager.shared.add {
            ThaliComboManager.shared
        }
    }
} 
 