//
//  ThaliAppShortcutsProvider.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import AppIntents

struct ThaliAppShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        // Register the dependency when shortcuts are accessed
        AppDependencyManager.shared.add {
            ThaliComboManager.shared
        }
        
        return [
            AppShortcut(
                intent: OrderThaliIntent(),
                phrases: [
                    "Order a thali combo",
                    "Build my thali",
                    "Create thali meal",
                    "Order Indian thali"
                ],
                shortTitle: "Order Thali",
                systemImageName: "circle.fill"
            )
        ]
    }
} 
 