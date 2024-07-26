# Day 16: Redacted / Skeleton Views in SwiftUI

On Day 16, I learned how to create redacted or skeleton views in SwiftUI. This technique is useful for indicating loading states by showing placeholder content.

## What I Learned

- How to use the `redacted(reason:)` modifier to show placeholder content.
- Creating skeleton views to simulate the appearance of loading data.
- Using `DispatchQueue` to simulate data fetching with a delay.

## Example Code
![alt text](<Screenshot 2024-07-26 at 11.38.43 PM.png>)

Here's an example demonstrating how to create redacted/skeleton views in SwiftUI:

```swift
// ContentView.swift
// Redacted
//
// Created by arpit verma on 26/07/24.

import SwiftUI

struct ContentView: View {
    @State var isloading = true
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(0...10, id: \.self) { _ in
                        PostView().frame(height: 150)
                            .padding(12)
                    }
                }
                .redacted(reason: isloading ? .placeholder : [])
            }
            .navigationTitle("Facebook")
            .onAppear(perform: {
                fetchData()
            })
        }
    }
    
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isloading = false
        }
    }
}

struct PostView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .unredacted()
                
                Text("Arpit Verma")
                    .bold()
                    .font(.system(size: 22))
            }
            Text("This is post description text so it goes too long")
                .font(.system(size: 24))
            Text("This is post description text so it goes too long")
                .font(.system(size: 24))
        }
    }
}

#Preview {
    ContentView()
}
