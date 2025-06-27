//
//  LatterOrderManager.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI

// Marked as @unchecked Sendable because it is used in a context requiring Sendable and does not contain concurrency-sensitive state.
final class LatteOrderManager: @unchecked Sendable {
    var choice : LocalizedStringResource = ""
    var count : Int = 1
    var milkPercentage = 20
    
    func orderLatte () async throws {
        try? await Task.sleep(for: .seconds(1))
    }
}

