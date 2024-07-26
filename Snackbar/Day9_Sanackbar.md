# Day 9: Snack Bar, Toast, and ZStack

On Day 9, I explored how to show snack bars and toast messages using the `PopupView` package in SwiftUI. Additionally, I utilized the `ZStack` layout to design the custom views for these popups.

## What I Learned

- How to use the `PopupView` package to display snack bars and toast messages.
- Customizing the appearance and behavior of popups.
- Implementing `ZStack` to create layered views in SwiftUI.

![alt text](<Screenshot 2024-07-18 at 8.47.05 AM.png>)

## Example Code

Here's an example demonstrating the use of `PopupView` to show a toast message:

```swift
import PopupView
import SwiftUI

struct ContentView: View {
    @State var isShowing = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.isShowing = true
                }, label: {
                    Text("Tap me")
                        .frame(width: 150, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(.system(size: 25).bold())
                        .cornerRadius(10)
                })
            }
            .navigationTitle(Text("title"))
            .popup(isPresented: $isShowing) {
                Toast()
            } customize: {
                $0
                    .type(.floater(verticalPadding: 10, horizontalPadding: 10, useSafeAreaInset: true))
                    .animation(.bouncy)
                    .autohideIn(3)
                    .position(.top)
                    .closeOnTap(true)
            }
        }
    }
}

struct Toast: View {
    var body: some View {
        ZStack {
            Color.green
            HStack {
                Image(systemName: "house")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding()
                    .foregroundColor(.white)
                Text("10 New posts")
                    .foregroundColor(.white)
                    .font(.system(size: 25).bold())
            }
            .padding()
        }
        .cornerRadius(10)
        .frame(height: 60)
        .padding()
    }
}

#Preview {
    ContentView()
}
