//
//  ChartsView.swift
//  CryptoNest
//
//  Created by arpit verma on 27/08/24.
//

import SwiftUI

struct ChartsView: View {
    private let data : [Double]
    
    private let maxY: Double
    private let minY : Double
    private let lineColor : Color
    private let startingDate : Date
    private let endingDate : Date
    @State private var percentage : CGFloat = 0
    
    
    init (coin : CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        let priceChange = ( data.last ?? 0 ) - ( data.first ?? 0 )
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coingeckoString: coin.lastUpdated ?? ""  )
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
        
    }
    var body: some View {
        VStack {
            chartView
                .frame(
                    height : 200)
                .background(
                    chartBackground
                )
                .overlay(
                    chartYAxis.padding(.horizontal , 4), alignment: .leading)
                
            chartDateLabels.padding(.horizontal , 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Preview : PreviewProvider {
    static var previews: some View {
        ChartsView(coin: dev.coin)
    }
}

extension ChartsView {
    private var chartView: some View {
        GeometryReader  { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count)*CGFloat(index+1)
                    let yAxis = maxY - minY
                    let yPosition = (1-CGFloat( (data[index] - minY ) / yAxis))*geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    } 
                  
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            .trim(from: 0, to: percentage )
            .stroke(lineColor, style: StrokeStyle(
                lineWidth: 1, lineCap: .round, lineJoin: .round))
            .shadow(color : lineColor, radius: 10, x: 0.0, y: 10.0)
            .shadow(color : lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20.0)
            .shadow(color : lineColor.opacity(0.7), radius: 10, x: 0.0, y: 30.0)
            .shadow(color : lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40.0)
        }
    }
    
    
    private var chartBackground : some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis : some View {
        VStack {
            Text(maxY.formattedWithAbbreviation())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviation())
            Spacer()
            Text(minY.formattedWithAbbreviation())
        }
    }
    
    private var chartDateLabels : some View {
        HStack {
            Text(startingDate.asShortDateString())
                .font(.caption)
            Spacer()
            Text(endingDate.asShortDateString())
                .font(.caption)
        }
    }
    
}


