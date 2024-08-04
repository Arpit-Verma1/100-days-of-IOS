//
//  CryptoNestApp.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

@main
struct CryptoNestApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }.navigationBarHidden(true)
        }
    }
}
