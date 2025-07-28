//
//  ContentView.swift
//  SIPGoalVisualizer
//
//  Created by Arpit Verma on 7/27/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GoalsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            GoalsListView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
                .tag(1)
            
            StockMarketView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Stocks")
                }
                .tag(2)
            
            AddGoalView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Goal")
                }
                .tag(3)
            
            ProfileView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
} 