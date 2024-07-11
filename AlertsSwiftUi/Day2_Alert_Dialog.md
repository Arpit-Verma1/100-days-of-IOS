# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 2: Showing Alert Dialog with Primary and Secondary Buttons

### What I Learned
Today, I learned how to display an alert dialog in a SwiftUI app. Alerts are a fundamental part of iOS apps, providing a way to present important information to the user and collect their input through buttons.

### Key Concepts
- **@State Property Wrapper**: Used to manage state in SwiftUI.
- **Alert**: A view that displays an alert message to the user.

### Example Code
Here is an example demonstrating how to show an alert dialog with primary and secondary buttons:

```swift
import SwiftUI

struct ContentView: View {
    @State private var alertPresented =  false;
    
    var body: some View {
        VStack {
            Button(action: {
                self.alertPresented = true
            }, label: {
                Text("Tap me")
            })
            .frame(width: 100, height: 200, alignment: .center)
            .padding(EdgeInsets())
            .background(Color.red)
            .cornerRadius(10)
        }
        .navigationTitle("Alerts")
        .alert(isPresented: $alertPresented, content: {
            Alert(
                title: Text("Alert Title"),
                message: Text("Alert Body"),
                primaryButton: .default(Text("Primary Button"), action: {
                    print("Primary button tapped")
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        })
    }
}

#Preview {
    ContentView()
}
