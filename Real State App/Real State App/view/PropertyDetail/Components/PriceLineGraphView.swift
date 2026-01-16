//
//  PriceGraphView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/11/26.
//

import SwiftUI

struct PriceLineGraphView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    @State private var hasAppeared: Bool = false
    
    init(basePrice: Int) {
        var prices: [Double] = []
        let base = Double(basePrice)
        
        var previousPrice = base
        for i in 0..<100 {
            
            let variation = Double.random(in: -0.05...0.1)
            let trend = Double(i) * 0.002
            
            
            let newPrice = previousPrice * 0.7 + base * (1 + variation + trend) * 0.3
            let price = max(newPrice, base * 0.7)
            
            prices.append(price)
            previousPrice = price
        }
        
        self.data = prices
        self.maxY = prices.max() ?? base
        self.minY = prices.min() ?? base
        
        // Set dates for 2020-2024
        let calendar = Calendar.current
        self.endingDate = Date()
        if let startDate = calendar.date(byAdding: .year, value: -4, to: endingDate) {
            self.startingDate = calendar.startOfDay(for: startDate)
        } else {
            self.startingDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1)) ?? Date()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price estimate")
                .font(.custom("HelveticaNowDisplay-Bold", size: 20))
                .foregroundColor(.black.opacity(0.7))
            
            VStack(spacing: 0) {
                chartView
                    .frame(height: 180)
                    .background(chartBackground)
            }
            .background(Color.white)
            .cornerRadius(12)
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
            }
        )
        .onPreferenceChange(ViewOffsetKey.self) { offset in
            let screenHeight = UIScreen.main.bounds.height
            if !hasAppeared && offset < screenHeight - 100 && offset > -200 {
                hasAppeared = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.linear(duration: 3.0)) {
                        percentage = 1.0
                    }
                }
            }
        }
    }
    
    private var chartView: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let totalPoints = CGFloat(data.count)
                    let currentX = percentage * geometry.size.width
                    
                    
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    
                    let firstX = geometry.size.width / totalPoints
                    let firstYAxis = maxY - minY
                    let firstY = (1 - CGFloat((data[0] - minY) / firstYAxis)) * geometry.size.height
                    path.addLine(to: CGPoint(x: firstX, y: firstY))
                    
                    var lastX = firstX
                    var lastY = firstY
                    var foundCurrentPoint = false
                    
                    for index in 1..<data.count {
                        let xPosition = geometry.size.width / totalPoints * CGFloat(index + 1)
                        let yAxis = maxY - minY
                        let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                        
                        if xPosition <= currentX {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                            lastX = xPosition
                            lastY = yPosition
                        } else {
                            let t = (currentX - lastX) / (xPosition - lastX)
                            let interpolatedY = lastY + (yPosition - lastY) * t
                            path.addLine(to: CGPoint(x: currentX, y: interpolatedY))
                            foundCurrentPoint = true
                            break
                        }
                    }
                    
                    if !foundCurrentPoint && percentage >= 1.0 {
                        let lastIndex = data.count - 1
                        let lastXPos = geometry.size.width / totalPoints * CGFloat(lastIndex + 1)
                        let lastYAxis = maxY - minY
                        let lastYPos = (1 - CGFloat((data[lastIndex] - minY) / lastYAxis)) * geometry.size.height
                        path.addLine(to: CGPoint(x: lastXPos, y: lastYPos))
                    }
                    
                    let finalX = foundCurrentPoint ? currentX : (percentage >= 1.0 ? geometry.size.width : currentX)
                    path.addLine(to: CGPoint(x: finalX, y: geometry.size.height))
                    
                    path.closeSubpath()
                }
               
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.1),
                            Color.black.opacity(0.01)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                
                Path { path in
                    for index in data.indices {
                        let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                        let yAxis = maxY - minY
                        let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        } else {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(Color.black.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
    }
    
    private var chartBackground: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.2))
            Spacer()
            Divider()
                .background(Color.gray.opacity(0.2))
            Spacer()
            Divider()
                .background(Color.gray.opacity(0.2))
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text("$\(Int(maxY).formatted())")
                .font(.custom("HelveticaNowDisplay-Bold", size: 10))
                .foregroundColor(.gray.opacity(0.6))
            Spacer()
            Text("$\(Int((maxY + minY) / 2).formatted())")
                .font(.custom("HelveticaNowDisplay-Bold", size: 10))
                .foregroundColor(.gray.opacity(0.6))
            Spacer()
            Text("$\(Int(minY).formatted())")
                .font(.custom("HelveticaNowDisplay-Bold", size: 10))
                .foregroundColor(.gray.opacity(0.6))
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(formatYear(startingDate))
                .font(.custom("HelveticaNowDisplay-Bold", size: 12))
                .foregroundColor(.gray)
            Spacer()
            Text(formatYear(endingDate))
                .font(.custom("HelveticaNowDisplay-Bold", size: 12))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func formatYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
}

extension Int {
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    PriceLineGraphView(basePrice: 3400)
        .padding()
}
