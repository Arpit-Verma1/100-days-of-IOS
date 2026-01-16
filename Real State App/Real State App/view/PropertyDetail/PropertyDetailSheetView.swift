//
//  PropertyDetailSheetView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/11/26.
//

import SwiftUI

struct PropertyDetailSheetView: View {
    let property: PropertyModel
    var onNavigateToFloorDetail: (String, Int) -> Void
    @State private var showFullDescription = false
    @State private var selectedFloorImage: String? = nil
    @State private var selectedFloorIndex: Int? = nil
    @Namespace private var heroAnimation
    
    var body: some View {
        VStack(spacing: 5) {
            if let floorImage = selectedFloorImage, let floorNumber = selectedFloorIndex {
                VStack(spacing: 0) {
                    FullscreenFloorPlanView(
                        property: property,
                        floorImage: floorImage,
                        floorNumber: floorNumber,
                        namespace: heroAnimation,
                        onBack: {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                selectedFloorImage = nil
                                selectedFloorIndex = nil
                            }
                        },
                        onNavigateToFloorDetail: onNavigateToFloorDetail
                    )
                    .frame(maxWidth: .infinity, minHeight: 400)
                    .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .background(
                            .white
                        )
                    Spacer(minLength: 0)
                    
                }
            } else {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Property Name
                            if selectedFloorImage == nil {
                                VStack (alignment: .leading, spacing: 0) {
                                    Text(property.propertyName)
                                        .font(.custom("HelveticaNowDisplay-Bold", size: 26))
                                        .foregroundColor(.black)
                                    
                                    HStack(spacing: 6) {
                                        Image(systemName: "map")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black.opacity(0.5))
                                        Text(property.location)
                                            .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                                            .foregroundColor(.black.opacity(0.5))
                                    }
                                    
                                }
                                Text(property.description)
                                    .font(.custom("HelveticaNowDisplay-Bold", size: 17))
                                    .foregroundColor(.black.opacity(0.3))
                                    .lineLimit(showFullDescription ? nil : 3)
                                
                                Button(action: {
                                    withAnimation {
                                        showFullDescription.toggle()
                                    }
                                }) {
                                    Text("Read more")
                                        .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                                        .foregroundColor(.black)
                                        .underline()
                                }
                                HStack(spacing: 10) {
                                    // Baths
                                    HStack(spacing: 6) {
                                        Image(systemName: "bathtub")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color.gray.opacity(0.7))
                                        Text("\(property.bathCount) baths")
                                            .font(.custom("HelveticaNowDisplay-Bold", size: 14))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    
                                    HStack(spacing: 6) {
                                        Image(systemName: "bed.double")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color.gray.opacity(0.7))
                                        Text("\(property.bedCount) beds")
                                            .font(.custom("HelveticaNowDisplay-Bold", size: 14))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    
                                    HStack(spacing: 6) {
                                        Image(systemName: "pencil.and.ruler")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color.gray.opacity(0.7))
                                        Text("\(formatArea(property.propertyArea)) sq")
                                            .font(.custom("HelveticaNowDisplay-Bold", size: 14))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                HStack(alignment: .lastTextBaseline, spacing: 4) {
                                    Text("$\(formatPrice(property.monthlyRent))")
                                        .font(.custom("HelveticaNowDisplay-Bold", size: 32))
                                        .foregroundColor(.black)
                                    Text("/ per month")
                                        .font(.custom("HelveticaNowDisplay-Bold", size: 17))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Amenities Section
                            if selectedFloorImage == nil {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Amenities")
                                        .font(.custom("HelveticaNowDisplay-Bold", size: 20))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                        
                                    ], alignment :.leading, spacing: 16) {
                                        AmenityItem(icon: "figure.pool.swim", title: "Infinity Pool")
                                        AmenityItem(icon: "water.waves", title: "Ocean View")
                                        AmenityItem(icon: "desktopcomputer", title: "Workspace")
                                        AmenityItem(icon: "dumbbell.fill", title: "Fitness")
                                        AmenityItem(icon: "beach.umbrella", title: "Beach Access")
                                        AmenityItem(icon: "wifi", title: "Wifi")
                                    }
                                    
                                    Button(action: {                                    }) {
                                        Text("Show all 24 amenities")
                                            .font(.custom("HelveticaNowDisplay-Bold", size: 14))
                                            .foregroundColor(.black.opacity(0.6))
                                            .underline()
                                    }
                                }
                                .padding(.top, 8)
                            }
                            
                            // Floor plans Section
                            if selectedFloorImage == nil {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Floor plans")
                                        .font(.custom("HelveticaNowDisplay-Bold", size: 20))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(Array(property.floors.enumerated()), id: \.element.id) { index, floor in
                                                FloorPlanCard(
                                                    floorImage: floor.image,
                                                    floorNumber: index + 1,
                                                    namespace: heroAnimation,
                                                    isSelected: selectedFloorImage == floor.image,
                                                    onTap: {
                                                        withAnimation(.spring(response: 0.9, dampingFraction: 0.8)) {
                                                            selectedFloorImage = floor.image
                                                            selectedFloorIndex = index + 1
                                                        }
                                                    }
                                                )
                                            }
                                            .padding(.horizontal, 4)
                                        }
                                    }
                                }
                                .padding(.top, 8)
                            }
                            
                            // Price estimate Section
                            PriceLineGraphView(basePrice: property.monthlyRent)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: {
                    }) {
                        VStack(spacing: 0) {
                            Text("Request a tour")
                                .font(.custom("HelveticaNowDisplay-Bold", size: 18))
                                .foregroundColor(.white.opacity(0.8))
                            Text("as early as tomorrow at 11am")
                                .font(.custom("HelveticaNowDisplay-Bold", size: 13))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                // Base black gradient
                                RoundedRectangle(cornerRadius: 38)
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
                                
                                RoundedRectangle(cornerRadius: 38)
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .background(
                        .white
                    )
            }
            
            
            
        }
        
    }
    
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

// Amenity Item Component
struct AmenityItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.black.opacity(0.5))
                .frame(height: 30)
            
            Text(title)
                .font(.custom("HelveticaNowDisplay-Bold", size: 14))
                .foregroundColor(.black.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        
    }
}


#Preview {
    PropertyDetailSheetView(
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
            image: "real state 3", video: "real state 1.mp4", floors: [ FloorModel(image: "plan1",video : "interior.mp4", name :"Floor 1" ), FloorModel(image: "plan2", video: "interior.mp4", name: "Floor 2"), FloorModel(image: "plan3", video: "interior.mp4", name: "Floor 3")]
        ),
        onNavigateToFloorDetail: { _, _ in }
    )
}
