//
//  ContentView.swift
//  DropDownMenu
//
//  Created by arpit verma on 27/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("hello world")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            // Add your action here
                        }) {
                            Label("Label", systemImage: "42.circle")
                        }
                        Button(action: {
                            // Add your action here
                        }) {
                            Label("RateApp", systemImage: "star")
                        }
                        Button(action: {
                            // Add your action here
                        }) {
                            Label("Settings", systemImage: "gear")
                        }
                        Button(action: {
                            // Add your action here
                        }) {
                            Label("Privacy", systemImage: "hand.raised")
                        }
                    } label: {
                        Label("Label", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Menu") // This should be inside the NavigationView
        }
    }
}

#Preview {
    ContentView()
}
