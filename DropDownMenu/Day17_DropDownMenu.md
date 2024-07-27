# Day 17: Showing Menu in Toolbar

On Day 17, I learned how to implement a dropdown menu in the toolbar of a SwiftUI application. This is useful for adding additional actions that the user can access from the toolbar.

## What I Learned

- How to use the `Menu` view to create a dropdown menu in the toolbar.
- Customizing the menu with different actions and icons.
- Adding the menu to the toolbar using `ToolbarItem`.

## Example Code

![alt text](<Screenshot 2024-07-27 at 11.37.19 PM.png>)
Here's an example demonstrating how to show a menu in the toolbar in SwiftUI:

```swift
// ContentView.swift
// DropDownMenu
//
// Created by arpit verma on 27/07/24.

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
