# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 4: Using Spacer and Creating Charts with ChartView Package

### What I Learned
Today, I learned how to use the `Spacer` view in SwiftUI to create flexible layouts. Additionally, I integrated the `ChartView` package to create various types of charts, including line charts, pie charts, and bar charts.

### Key Concepts
- **Spacer**: A flexible space that expands along the major axis of its containing stack layout, pushing the adjacent views apart.
- **ChartView Package**: A Swift package that provides easy-to-use and customizable charts for SwiftUI.

### Adding the ChartView Package
To add the `ChartView` package to your project, include the following dependency in your `Package.swift` file:
```swift
.package(url: "https://github.com/AppPear/ChartView", from: "2.8.0")
```
### Example Code
Here is a simple example demonstrating the use of `ChartView` and `Spacer`:
![image](https://github.com/user-attachments/assets/2292a31c-4caa-402e-91f0-5ad2858cf557)
```
import SwiftUICharts
import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            LineChartView(data: [1,2,3,-3,4], title: "Chart1")
            Spacer()
            PieChartView(data: [2,76,23,6,5,34,2], title: "Chart2")
            Spacer()
            BarChartView(data: ChartData(values: [("a",1),("b",3),("v",2)]), title:"Chart3")
            Spacer()
            LineView(data: [1,2,32,2])
     
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

