//
//  ContentView.swift
//  ChartsSwift
//
//  Created by arpit verma on 13/07/24.
//
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
