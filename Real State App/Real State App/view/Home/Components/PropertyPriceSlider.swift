//
//  PropertyPriceSlider.swift
//  Real State App
//
//  Created by Arpit Verma on 1/10/26.
//

import SwiftUI

struct PropertyPriceSlider: View {
    @State var offsetXLeftThumb: CGFloat = 50
    @State var offsetXRightThumb: CGFloat = 100
    
    @State var currentOffsetXLeftThumb: CGFloat = 0
    @State var currentOffsetXRightThumb: CGFloat = 0
    @State var isDragging : Bool = false
    @State var barData : [CGFloat]
    
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            
            let width = geometry.size.width
            
            let lowValueLbl = offsetXLeftThumb * SliderConstant.sliderUnit / (width - SliderConstant.thumbWidth)
            let highValueLbl = offsetXRightThumb * SliderConstant.sliderUnit / (width - SliderConstant.thumbWidth)
            
            VStack(spacing: 8) {
                PriceBarGraphView(
                    barData: barData,
                    leftThumbPosition: offsetXLeftThumb + currentOffsetXLeftThumb,
                    rightThumbPosition: offsetXRightThumb + currentOffsetXRightThumb,
                    totalWidth: width
                )
                .frame(height: 120)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: SliderConstant.sliderHeight / 2)
                        .foregroundColor(Color(hex : "#f3f5f7"))
                        .frame(width: width, height: SliderConstant.sliderHeight)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: offsetXRightThumb + currentOffsetXRightThumb - offsetXLeftThumb - currentOffsetXLeftThumb + 20)
                        .frame(height: SliderConstant.sliderHeight - 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .offset(x: offsetXLeftThumb + currentOffsetXLeftThumb + SliderConstant.thumbWidth - 15)
                    
                    HStack(spacing: 0) {
                        
                        SliderThumbView(currentOffsetX: $currentOffsetXLeftThumb,
                                        offsetX: $offsetXLeftThumb, isDragging: $isDragging ,
                                        minX: -offsetXLeftThumb ,
                                        maxX: offsetXRightThumb - offsetXLeftThumb)
                        
                        SliderThumbView(currentOffsetX: $currentOffsetXRightThumb,
                                        offsetX: $offsetXRightThumb, isDragging: $isDragging,
                                        minX: -offsetXRightThumb + offsetXLeftThumb ,
                                        maxX: width - SliderConstant.thumbWidth * 2 - offsetXRightThumb)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        if  Int(isDragging ? offsetXLeftThumb + currentOffsetXLeftThumb : offsetXLeftThumb) > 10 {
                            PriceTooltip(price: Int(isDragging ? offsetXLeftThumb + currentOffsetXLeftThumb : offsetXLeftThumb))
                                .offset(x: (offsetXLeftThumb + currentOffsetXLeftThumb - 40))
                            
                        }
                        if  Int(isDragging ? offsetXRightThumb + currentOffsetXRightThumb : offsetXRightThumb) > 10 {
                            PriceTooltip(price: Int(isDragging ? offsetXRightThumb + currentOffsetXRightThumb : offsetXRightThumb))
                                .offset(x: (offsetXRightThumb + currentOffsetXRightThumb - 30))
                            
                        }
                    }
                    .offset(y : 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
        })
    }
}

struct PriceBarGraphView: View {
    let barData: [CGFloat]
    let leftThumbPosition: CGFloat
    let rightThumbPosition: CGFloat
    let totalWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(0..<barData.count, id: \.self) { index in
                    let barWidth = geometry.size.width / CGFloat(barData.count)
                    let barXPosition = barWidth * CGFloat(index) + barWidth / 2
                    
                    let isSelected = barXPosition >= leftThumbPosition && barXPosition <= rightThumbPosition
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: max(barWidth * 0.7, 2), height: geometry.size.height * barData[index])
                        .padding(.horizontal, 2)
                }
            }
        }
    }
}

struct PriceTooltip: View {
    let price: Int
    
    var body: some View {
        Text("₹\(price)")
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(#colorLiteral(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)),
                                    Color.black
                                ]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )

                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.05),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .padding(.top, 2)
                        .mask(
                            RoundedRectangle(cornerRadius: 28)
                        )
                }
            )
    }
}

enum SliderConstant {
    static let sliderHeight: CGFloat = 20
    static let thumbWidth: CGFloat = 10
    static let tooltipHeight: CGFloat = 36
    static let sliderUnit: CGFloat = 12000
}



struct SliderThumbView: View {
    
    @Binding var currentOffsetX: CGFloat
    @Binding var offsetX: CGFloat
    @Binding var isDragging: Bool
    var minX: CGFloat
    var maxX: CGFloat
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: SliderConstant.thumbWidth - 6, height: SliderConstant.thumbWidth - 6)
                .foregroundColor(.black)
            
            
        }
        //        .offset(y: 20)
        .modifier(SliderDraggableModifier(currentOffsetX: $currentOffsetX,
                                          offsetX: $offsetX,
                                          isDragging: $isDragging, minX: minX,
                                          maxX: maxX))
    }
}

struct SliderDraggableModifier : ViewModifier {
    
    @Binding var currentOffsetX: CGFloat
    @Binding var offsetX: CGFloat
    @State var scale: CGFloat = 1
    @Binding var isDragging : Bool
    var minX: CGFloat
    var maxX: CGFloat
    
    func body(content: Content) -> some View {
        content
                    .scaleEffect(scale)
            .offset(x: offsetX + currentOffsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        
                        isDragging = true
                                                if scale == 1 {
                                                    withAnimation(.linear(duration: 0.1)) {
                                                        scale = 1.36
                                                    }
                                                }
                        currentOffsetX = max(minX, min(maxX, value.translation.width))
                    }
                    .onEnded { value in
                        offsetX += currentOffsetX
                        currentOffsetX = 0
                        isDragging = false
                                                withAnimation(.linear(duration: 0.1)) {
                                                    scale = 1
                                                }
                    }
            )
    }
    
}


#Preview {
     let barData: [CGFloat] = {
        var data: [CGFloat] = []
        // Create a bell curve-like distribution with 50 bars
        for i in 0..<35 {
            let x = Double(i - 25) / 5.0
            let height = exp(-pow(x, 2) / 2.0) * 0.8 + Double.random(in: 0.1...0.2)
            data.append(CGFloat(height))
        }
        return data
    }()
    PropertyPriceSlider(
        barData : barData
        
    )
}
