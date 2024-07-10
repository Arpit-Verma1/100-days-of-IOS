# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift. 

## Day 1: Navigation in iOS using `NavigationLink`

### What I Learned
Today, I explored how to implement navigation in an iOS app using `NavigationLink`. This is a crucial aspect of iOS development as it allows users to move between different views within an application.

### Key Concepts
- **NavigationView**: A container view that provides a navigation bar and enables navigation between views.
- **NavigationLink**: A view that creates a button to navigate to a destination view.

### Example Code
Here is a simple example demonstrating the use of `NavigationView` and `NavigationLink`:

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Day 1 of my iOS Learning Journey!")
                    .font(.headline)
                    .padding()

                NavigationLink(destination: DetailView()) {
                    Text("Go to Detail View")
                        .font(.subheadline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("This is the Detail View!")
            .font(.largeTitle)
            .padding()
            .navigationTitle("Detail")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
