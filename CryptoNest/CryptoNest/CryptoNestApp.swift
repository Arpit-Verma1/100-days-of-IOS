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
    @State private var showLaunchView : Bool = true
    
    
    init() {
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    }
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                
                .environmentObject(vm)
                
                ZStack{
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }.zIndex(2.0)
               
            }
            
            
        }
    }
}
