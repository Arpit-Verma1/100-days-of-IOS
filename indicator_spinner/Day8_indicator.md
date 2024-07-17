# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

# Day 8: Loading Indicators / Spinners

## What I Learned

- How to use `ActivityIndicatorView` to show loading indicators in SwiftUI.
- Customizing the appearance of spinners with different styles and colors.
- Managing the visibility of spinners using state variables.

![alt text](<Screenshot 2024-07-17 at 1.42.42 PM.png>)
## Example Code

Here's an example demonstrating the use of different types of loading indicators:

```swift
// ContentView.swift
// indicator_spinner
//
// Created by arpit verma on 17/07/24.

import ActivityIndicatorView
import SwiftUI

struct ContentView: View {
    @State var loading = false;
    var body: some View {
        VStack {
            ActivityIndicatorView(isVisible: $loading, type: .default(count: 8))
                .foregroundColor(.red)
                .frame(width: 100, height: 100)
                .padding()

            ActivityIndicatorView(isVisible: $loading, type: .equalizer(count: 5))
                .foregroundColor(.purple)
                .frame(width: 100, height: 100)
                .padding()

            ActivityIndicatorView(isVisible: $loading, type: .rotatingDots(count: 7))
                .foregroundColor(.orange)
                .frame(width: 100, height: 100)
                .padding()

            Button(action: {
                self.loading = true
            }, label: {
                Text("Show Loading Indicator")
            })
            .frame(width: 200, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
