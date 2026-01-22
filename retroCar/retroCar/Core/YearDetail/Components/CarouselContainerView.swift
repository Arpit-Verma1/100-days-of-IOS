//
//  CarouselContainerView.swift
//  retroCar
//
//  Created by Arpit Verma on 1/19/26.
//

import SwiftUI

struct CarouselContainerView: View {
    @State var allYears: [YearModel] = years
    @Binding var currentIndex: Int
    @Binding var isExpanded: Bool
    @Binding  var showBottomCards: Bool
    @Binding var dragOffset: CGFloat
    @Binding var isTransitioning: Bool 
    @Binding var currentImageOpacity: Double
    @Binding var previousImageOpacity: Double
    @Binding var nextImageOpacity: Double
    @Binding var bottomCardOffset: CGFloat
    @Binding var verticalDragOffset: CGFloat
    @Binding var yearTextOffset: CGFloat
    @Binding var yearTextOpacity: Double
    @Binding var lineOpacity: Double
    @Binding var carImageOpacity: Double
    @Binding var detailRowsOffset: CGFloat
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let cardWidth = screenWidth - 10
            let screenCenter = screenWidth / 2
            let spacerHeight: CGFloat = isExpanded ? 0 : 130
            let carImageHeight: CGFloat = isExpanded ? 0 : (230 * carImageOpacity)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<allYears.count, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        heroCardView(for: allYears[index], isCurrent: index == currentIndex)
                            .frame(width: cardWidth)
                            .padding(.horizontal, 10)
                        
                        // Car image
                        if !isExpanded {
                            Spacer()
                                .frame(height: spacerHeight)
                            Image(getImageName(for: allYears[index].year))
                                .resizable()
                                .frame(height: carImageHeight)
                                .frame(width: cardWidth + 30)
                                .offset(x:20)
                                .opacity(index == currentIndex ? (currentImageOpacity * carImageOpacity) :
                                        (index == currentIndex - 1 ? previousImageOpacity :
                                         (index == currentIndex + 1 ? nextImageOpacity : 0)))
                        }
                        
                    }
                    .frame(width: cardWidth + 20, alignment: .top)
                }
            }
            .offset(x: -CGFloat(currentIndex) * (cardWidth + 20) - screenCenter + (cardWidth + 0) / 2 + dragOffset)
            .frame(maxHeight: isExpanded ? .infinity : geometry.size.height, alignment: .top)
        }
    }
    private func getImageName(for year: String) -> String {
        // Extract the decade number (e.g., "1970s" -> "1970")
        let decade = year.replacingOccurrences(of: "s", with: "")
        return decade
    }
    
    private func heroCardView(for model: YearModel, isCurrent: Bool = false) -> some View {
        let yearText = Text(model.year.uppercased())
            .font(Font.custom("rolf", size: 110,))
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
        
        let companyText = Text(model.ratroCar.carCompany)
            .font(Font.custom("newston", size: 105))
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
        
        let modelText = Text(model.ratroCar.modelName)
            .font(Font.custom("rolf", size: 60))
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
        
        let line = Rectangle()
            .fill(.black)
            .frame(height: 2)
            .padding(.top, 5)
        
        let background = RoundedRectangle(cornerRadius: 10)
            .fill( model.color)
        
        let yearTextSectionHeight: CGFloat = isCurrent ? (190 * yearTextOpacity) : 190
        let lineSectionHeight: CGFloat = isCurrent ? (7 * lineOpacity) : 7
        let dynamicTopPadding: CGFloat = isCurrent ? (-40 * yearTextOpacity) : -40
        
        return VStack(alignment: .leading, spacing: 0) {
            if yearTextOpacity > 0 {
                HStack(alignment: .lastTextBaseline){
                    
                    Group {
                        if isCurrent {
                            yearText.matchedGeometryEffect(id: "year-\(model.id)", in: namespace)
                        } else {
                            yearText
                        }
                    }
                    .offset(y: isCurrent ? yearTextOffset : 0)
                    .opacity(isCurrent ? yearTextOpacity : 1.0)
                    Spacer()
                    if isCurrent {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 35,weight: .bold))
                            .opacity(yearTextOpacity)
                            .onTapGesture {
                                // Animate bottom cards out first
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showBottomCards = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onDismiss()
                                }
                            }
                    }
                }
                .frame(height: yearTextSectionHeight, alignment: .top)
                .opacity(isCurrent ? yearTextOpacity : 1.0)
                
                Group {
                    if isCurrent {
                        line.matchedGeometryEffect(id: "line-\(model.id)", in: namespace)
                    } else {
                        line
                    }
                }
                
                
                .frame(height: lineSectionHeight)
                .opacity(isCurrent ? lineOpacity : 1.0)
                .padding(.bottom, 0)
                
            }
            HStack(alignment:.lastTextBaseline) {
                Group {
                    if isCurrent {
                        companyText.matchedGeometryEffect(id: "company-\(model.id)", in: namespace)
                    } else {
                        companyText
                    }
                }
                Group {
                    if isCurrent {
                        modelText.matchedGeometryEffect(id: "model-\(model.id)", in: namespace)
                    } else {
                        modelText
                    }
                }
                Spacer()
            }
            .padding(.top, isCurrent && isExpanded ? 10 : 0)
        }
        
        .padding(10)
        .padding(.top, dynamicTopPadding)
        .padding(.bottom , isCurrent && isExpanded ? -10 : -20)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if isCurrent {
                    background.matchedGeometryEffect(id: "card-\(model.id)", in: namespace)
                } else {
                    background
                }
            }
        )
    }
}

//#Preview {
//    CarouselContainerView(allYears: <#Binding<[YearModel]>#>, currentIndex: <#Binding<Int>#>, isExpanded: <#Binding<Bool>#>, showBottomCards: <#Binding<Bool>#>, dragOffset: <#Binding<CGFloat>#>, isTransitioning: <#Binding<Bool>#>, currentImageOpacity: <#Binding<Double>#>, previousImageOpacity: <#Binding<Double>#>, nextImageOpacity: <#Binding<Double>#>, bottomCardOffset: <#Binding<CGFloat>#>, verticalDragOffset: <#Binding<CGFloat>#>, yearTextOffset: <#Binding<CGFloat>#>, yearTextOpacity: <#Binding<Double>#>, lineOpacity: <#Binding<Double>#>, carImageOpacity: <#Binding<Double>#>, detailRowsOffset: <#Binding<CGFloat>#>, namespace: <#Binding<Namespace.ID>#>, onDismiss: <#Binding<() -> Void>#>)
//}
