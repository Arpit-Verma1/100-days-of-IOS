# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 3: Grid View with Adaptive, Flexible, and Fixed Layouts

### What I Learned
Today, I explored how to create grid views in SwiftUI using `LazyVGrid` with adaptive, flexible, and fixed layouts. These layouts allow for different ways to organize items in a grid, providing flexibility and control over the appearance of the grid.

### Key Concepts
- **LazyVGrid**: A container view that arranges its child views in a grid that grows vertically, creating items only when they are needed.
- **GridItem**: Defines a single item in a grid, specifying its size and spacing.


### Grid Layout Types
1. **Adaptive Layout**: Allows the grid to adjust the number of columns to fit the available space. Each item has a minimum width, and the grid adapts to accommodate as many items as possible within the given width.
2. **Flexible Layout**: Allows each item to have a flexible width within a specified range. This ensures that the items resize to fit the available space while maintaining a minimum and maximum width.
3. **Fixed Layout**: Specifies a fixed width for each item. The grid will have a fixed number of columns regardless of the available space.

![WhatsApp Image 2024-07-12 at 9 59 46 PM](https://github.com/user-attachments/assets/a98b11d5-c80b-461b-8947-63d875a30780)
### Example Code
Here is an example demonstrating a grid view with adaptive layout:

```swift
import SwiftUI

struct ContentView: View {
    let items = Array(1...100)

    var body: some View {
        ScrollView {
            // Adaptive layout
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
