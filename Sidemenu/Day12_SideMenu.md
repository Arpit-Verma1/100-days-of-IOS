# Day 12: Side Menu, UIScreen, ZStack, GeometryReader, and EmptyView

On Day 12, I learned about creating a side menu in SwiftUI. This involved understanding how to use `UIScreen` to get screen dimensions, `ZStack` for layering views, `GeometryReader` for flexible layout, and `EmptyView` for handling empty states.

## What I Learned

- How to create a side menu using SwiftUI.
- Using `UIScreen.main.bounds` to get screen dimensions.
- Leveraging `ZStack` for layering views and managing their order.
- Utilizing `GeometryReader` for responsive layouts.
- Implementing `EmptyView` to handle empty or placeholder states.

## Example Code
![alt text](<Screenshot 2024-07-21 at 11.28.47 PM.png>)

Here's an example demonstrating how to create a side menu with the mentioned components:

```swift
// ContentView.swift
// SideMenuExample
//
// Created by arpit verma on 21/07/24.

import SwiftUI

struct MenuItem: Identifiable {
    var id = UUID()
    var title: String
}

struct MenuContent: View {
    var items = [
        MenuItem(title: "Home"),
        MenuItem(title: "Profile"),
        MenuItem(title: "Rewards"),
        MenuItem(title: "Profile"),
        MenuItem(title: "Home"),
        MenuItem(title: "Profile"),
        MenuItem(title: "Settings"),
        MenuItem(title: "Logout")
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1.0))
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(items) { item in
                    HStack {
                        Image(systemName: "house").foregroundColor(.white)
                        Text(item.title)
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .multilineTextAlignment(.leading)
                    }
                    .onTapGesture {
                        // Handle menu item tap
                    }
                    Spacer()
                    Divider()
                }
                .padding()
            }
        }
    }
}

struct SideMenu: View {
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.5))
            .opacity(self.menuOpened ? 1 : 0)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                self.toggleMenu()
            }
            
            HStack {
                MenuContent()
                    .frame(width: width, height: UIScreen.main.bounds.height)
                    .offset(x: self.menuOpened ? 0 : -self.width)  // Ensure the menu is off-screen when closed
                    .animation(.default, value: menuOpened)  // Add animation binding
                
                Spacer()  // Push content to the left
            }
        }
    }
}

struct ContentView: View {
    @State var menuOpened = false
    
    var body: some View {
        ZStack {
            Button(action: {
                self.menuOpened.toggle()
            }, label: {
                Text("Open Menu")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            SideMenu(width: UIScreen.main.bounds.width / 1.6, menuOpened: menuOpened, toggleMenu: toggleMenu)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
}

#Preview {
    ContentView()
}
