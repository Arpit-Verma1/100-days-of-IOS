# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 6: Creating an Onboarding Screen with ConcentricOnboarding Package

### What I Learned
Today, I learned how to create an engaging onboarding screen for an app using the `ConcentricOnboarding` package. Onboarding screens are crucial for introducing new users to the app's features and ensuring a smooth user experience from the start.

### Key Concepts
- **ConcentricOnboarding**: A Swift package that provides a highly customizable and visually appealing onboarding experience with concentric circles.
- **OnboardingPage**: A custom view used to represent each onboarding screen.

### Adding the ConcentricOnboarding Package
To add the `ConcentricOnboarding` package to your project, include the following dependency in your `Package.swift` file:
```swift
.package(url: "https://github.com/exyte/ConcentricOnboarding", from: "0.1.0")
```
### Example Code
Here is a simple example demonstrating the use of `CocentricOnboardingView`:
![image](https://github.com/user-attachments/assets/02e9d07b-bd9e-4fa7-9a8f-fc7dd672a0d6)

```
import SwiftUI
import ConcentricOnboarding

struct ContentView: View {
    var body: some View {
        ConcentricOnboardingView(
            pageContents: [
             (
                    view: OnboardingPage(
                        title: "Home",
                        message: "Welcome Back",
                        image: "house"
                    ),
                    background: .red
                ),
                (
                    view: OnboardingPage(
                        title: "Feed",
                        message: "Stay up to Date",
                        image: "bell"
                    ),
                    background: .purple
                ),
                (
                    view: OnboardingPage(
                        title: "Chat",
                        message: "Chat with Friends",
                        image: "message"
                    ),
                    background: .orange
                )
            ]
        )
    }
}

struct OnboardingPage: View {
    var title: String
    var message: String
    var image: String

    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.system(size: 40))
                .bold()
                .foregroundColor(.white)

            Image(systemName: image)
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)

            Text(message)
                .font(.system(size: 30))
                .bold()
                .foregroundColor(.white)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
