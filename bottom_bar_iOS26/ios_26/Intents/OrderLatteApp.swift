//
//  OrderLatteApp.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

//@main
struct OrderLatteApp : App {
    init () {
        AppDependencyManager.shared.add {
            LatteOrderManager() }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
