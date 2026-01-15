//
//  propertyCard.swift
//  Real State App
//
//  Created by Arpit Verma on 1/4/26.
//

import SwiftUI

struct PropertyCardView: View {
    @State var property: PropertyModel
    @State private var isFavorite: Bool = false
    
    var body: some View {
        NavigationLink(destination: PropertyDetailView(property: property)) {
            ZStack(alignment: .topTrailing) {
                Image(property.image)
                    .resizable()
                    .frame(width: 370, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        Image(property.image)
                            .resizable()
                            .frame(width: 370, height: 300)
                            .blur(radius: 8)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black]),
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    )
                
                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red.opacity(0.8) : .white)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(.blue.opacity(0.1))
                        )
                }
                .glassEffect(.clear)
                .padding(16)
                .buttonStyle(PlainButtonStyle())
                
                HStack(spacing: 50) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(property.propertyName)
                            .font(.custom("HelveticaNowDisplay-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        HStack(alignment: .lastTextBaseline, ) {
                            Text("\(property.bedCount)"
                            ).foregroundColor(.white)
                                .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                            Text("beds")
                            
                                .foregroundColor(.white.opacity(0.6))
                                .font(.custom("HelveticaNowDisplay-Bold", size: 12))
                            Text("\(property.bathCount)")
                                .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                                .foregroundColor(.white)
                            Text("baths")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.custom("HelveticaNowDisplay-Bold", size: 12))
                            Text("\(property.propertyArea)")
                                .foregroundColor(.white)
                                .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                            Text("sqft")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.custom("HelveticaNowDisplay-Bold", size: 12))
                        }
                        
                    }
                    VStack(alignment: .leading,spacing: 10) {
                        Text("$\(formatPrice(property.monthlyRent))")
                            .font(.custom("HelveticaNowDisplay-Bold", size: 18))
                            .foregroundColor(.white)
                        Text("per month")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.custom("HelveticaNowDisplay-Bold", size: 12))
                    }
                }
                .offset(x: -40, y : 230)
            }
        }
        .buttonStyle(PlainButtonStyle())}
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
    
    private func formatArea(_ area: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: area)) ?? "\(area)"
    }
}

#Preview {
    PropertyCardView(
        property: PropertyModel(
            bedCount: 5,
            bathCount: 4,
            propertyName: "Live Oak Meadows",
            monthlyRent: 4500,
            propertyArea: 2155,
            fhaEnable: false,
            singleSotry: true,
            description: "Escape to luxury in this modern architectural gem perched above the coastline. Midnight Ocean Villa offers panoramic ocean views",
            location: "Riverton, NJ",
            image: "real state 3", video: "real state 1.mp4",floors: [ FloorModel(image: "plan1",video : "plan1", name :"Floor 1" ), FloorModel(image: "plan2", video: "plan2", name: "Floor 2"), FloorModel(image: "plan3", video: "plan3", name: "Floor 3")]
        )
    )
    .padding()
}
