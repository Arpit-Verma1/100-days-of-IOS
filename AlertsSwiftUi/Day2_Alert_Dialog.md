# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 2: Showing Alert Dialog with Primary and Secondary Buttons

### What I Learned
Today, I learned how to display an alert dialog in a SwiftUI app. Alerts are a fundamental part of iOS apps, providing a way to present important information to the user and collect their input through buttons.

### Key Concepts
- **@State Property Wrapper**: Used to manage state in SwiftUI.
- **Alert**: A view that displays an alert message to the user.

- ![image](https://github.com/user-attachments/assets/bccb7275-6ce3-4a8a-b606-a85714679c87)


### Example Code
Here is an example demonstrating how to show an alert dialog with primary and secondary buttons:

```swift
import SwiftUI

struct ContentView: View {
    @State private var alertPresented =  false;
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.alertPresented = true
                }, label: {
                    Text("Tap me")
                        .padding()
                        .foregroundColor(.white)
                        .font(.system(size: 35))
                })
                .frame(width: 200, height: 70, alignment: .center)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .alert(isPresented: $alertPresented, content: {
                    Alert(title: Text("Did you like it?"), message: Text("Day2 Alert Dialog Learning"), dismissButton: .default(Text("Yes, I loved It")))
                })
            }
            .navigationTitle("Alerts Screen")
        }
    }
}

#Preview {
    ContentView()
}
