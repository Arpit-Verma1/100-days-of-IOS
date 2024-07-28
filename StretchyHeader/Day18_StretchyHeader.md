# Day 18: Stretchy Header

On Day 18, I learned how to create a stretchy header in SwiftUI. This effect is commonly seen in apps where the header image expands and contracts as the user scrolls.

## What I Learned

- How to use `GeometryReader` to create a stretchy header effect.
- Managing view offsets and frame adjustments based on scroll position.
- Displaying dynamic content with a stretchy header.

## Example Code
![alt text](<Screenshot 2024-07-28 at 12.54.19 PM.png>)
Here's an example demonstrating how to implement a stretchy header in SwiftUI:

```swift
// ContentView.swift
// StretchyHeader
//
// Created by arpit verma on 28/07/24.

import SwiftUI

struct CardData {
    let id: Int
    let title: String
}

struct ContentView: View {
    let comics = [
        "Spider-Man",
        "Batman",
        "Superman",
        "Wonder Woman",
        "The Flash",
        "X-Men",
        "The Avengers"
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                GeometryReader { proxy in
                    let global = proxy.frame(in: .global)
                    Image("8")
                        .resizable()
                        .offset(y: global.minY > 0 ? -global.minY : 0)
                        .frame(height: global.minY > 0 ? UIScreen.main.bounds.height / 2 + global.minY : UIScreen.main.bounds.height / 2)
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                
                VStack {
                    ForEach(0..<comics.count, id: \.self) { index in
                        let data = CardData(id: index+1, title: self.comics[index])
                        CardView(card: data).padding()
                    }
                }
            }
        }
    }
}

struct CardView: View {
    let card: CardData
    
    var body: some View {
        HStack (alignment: .center){
            Image("\(card.id)")
                .resizable()
                .cornerRadius(10)
                .scaledToFit()
                .frame(width: 100, height: 100)
            VStack(alignment: .leading){
                Spacer()
                Text(card.title)
                    .bold()
                    .font(.system(size: 20, weight: .bold)).padding(5)
                
                Text("A thrilling tale of heroes")
                    .bold()
                    .font(.system(size: 15, weight: .bold))
                Spacer()
            }
            Spacer()
            Button(action: {
                print("Button Clicked")
            }, label: {
                Label {
                    Text("Like")
                        .foregroundColor(.pink)
                        .font(.system(size: 25, weight: .bold))
                } icon: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.pink)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
