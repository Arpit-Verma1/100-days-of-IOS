# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 3: Grid View with Adaptive and Fixed Layouts

### What I Learned
Today, I learned how to create a grid view in SwiftUI using `LazyVGrid` with adaptive and fixed layouts. Grids are a versatile way to present data in a structured manner, and SwiftUI makes it easy to implement them with flexible layouts.

### Key Concepts
- **LazyVGrid**: A container view that arranges its child views in a grid that grows vertically, creating items only when they are needed.
- **GridItem**: Defines a single item in a grid, specifying its size and spacing.

### Example Code
Here is an example demonstrating a grid view with adaptive layout:


```swift
import SwiftUI

struct ContentView: View {
    let items = Array(1...100)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 20) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

@main
struct GridViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
