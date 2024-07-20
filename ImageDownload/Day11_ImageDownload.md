# Day 11: Loading Images from the Internet

On Day 11, I learned about loading images from the internet in SwiftUI using the `SwURL` package. This package provides a convenient way to download and cache images, ensuring efficient and smooth image loading in the application.

## What I Learned

- How to use `SwURL` to download images from the internet.
- Displaying a progress indicator while the image is being downloaded.
- Caching images for better performance.

## Example Code
![alt text](<Screenshot 2024-07-20 at 7.51.05 PM.png>)

Here's an example demonstrating how to load and display an image from the internet using `SwURL`:

```swift
// ContentView.swift
// ImageDownload
//
// Created by arpit verma on 20/07/24.

import SwiftUI
import SwURL

struct ContentView: View {
    init(){
        SwURL.setImageCache(type: .persistent)
    }
    var body: some View {
        NavigationView {
            VStack {
                SwURLImage(
                    url: URL(string: "https://share.ftimg.com/aff/flamingtext/2013/09/10/flamingtext__23132978028750356.png")!
                ).progress { progress in
                    Text("\(Int(progress * 100))%")
                }
                .frame(width: 300, height: 300)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                Text("Hello, World!")
            }
        }
    }
}

#Preview {
    ContentView()
}
