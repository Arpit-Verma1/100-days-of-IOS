# Day 13: Opening Web Links in SwiftUI

On Day 13, I learned how to open web links in SwiftUI using the `Link` view. This view provides a simple way to create tappable links that open URLs in the default web browser.

## What I Learned

- How to use the `Link` view to open web URLs.
- Customizing the appearance of the link with `Label`, `Image`, and `Text`.
- Setting up the `Link` view to navigate to a specified URL when tapped.

## Example Code
![alt text](<Screenshot 2024-07-22 at 11.56.03 PM.png>)
Here's an example demonstrating how to open a web link using SwiftUI:

```swift
// ContentView.swift
// UrlLauncher
//
// Created by arpit verma on 22/07/24.

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Link(destination: URL(string: "https://www.goggle.com")!, label: {
                Label(
                    title: { Text("Search Goggle").bold() },
                    icon: { Image(systemName: "magnifyingglass").font(.system(size: 22, weight: .bold, design: .default)) }
                )
                .frame(width: 250, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
