//
//  CryptoNestApp.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

@main
struct CryptoNestApp: App {
    
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                HomeView()
            }.environmentObject(vm)
        }
    }
}
