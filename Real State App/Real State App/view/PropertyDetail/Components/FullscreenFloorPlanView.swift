//
//  FullscreenFloorPlanView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/12/26.
//


import SwiftUI
// Fullscreen Floor Plan View
struct FullscreenFloorPlanView: View {
    let property: PropertyModel
    let floorImage: String
    let floorNumber: Int
    let namespace: Namespace.ID
    let onBack: () -> Void
    var onNavigateToFloorDetail: (String, Int) -> Void
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var hotspotPoints: [(x: CGFloat, y: CGFloat)] = []
    @State private var tappedHotspotIndex: Int? = nil
    @State private var floorPlanScale: CGFloat = 1.3
    @State private var floorPlanBlur: CGFloat = 0
    @State private var selectedFloorVideo: String = ""
    
    var body: some View {
        GeometryReader { mainGeometry in
            ZStack {
                VStack {
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 1.5, dampingFraction: 0.8)) {
                                    rotationAngle = 0
                                    scale = 1.0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    onBack()
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            
                            Text("Floor \(floorNumber)")
                                .font(.custom("HelveticaNowDisplay-Bold", size: 30))
                                .foregroundColor(.black.opacity(0.6))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .zIndex(2)
                    .opacity(tappedHotspotIndex == nil ? 1.0 : 0.0)
                    
                    GeometryReader { geometry in
                        ZStack {
                            Image(floorImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .matchedGeometryEffect(id: "floorPlan_\(floorImage)", in: namespace)
                                .blur(radius: floorPlanBlur)
                            
                        if tappedHotspotIndex == nil {
                            ForEach(Array(hotspotPoints.enumerated()), id: \.offset) { index, point in
                                BlinkingHotspot(
                                    delay: Double(index) * 0.2,
                                    onTap: {
                                        tappedHotspotIndex = index
                                        let currentFloorIndex = floorNumber - 1
                                        if currentFloorIndex < property.floors.count {
                                            selectedFloorVideo = property.floors[currentFloorIndex].video
                                        } else {
                                            selectedFloorVideo = "interior.mp4"
                                        }
                                        startZoomAnimation(screenSize: mainGeometry.size)
                                    }
                                )
                                .position(
                                    x: geometry.size.width * point.x,
                                    y: geometry.size.height * point.y
                                )
                            }
                        }
                        }
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(floorPlanScale)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
            .zIndex(1)
            
            VStack {
                Spacer()
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
            }
        .background(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            hotspotPoints = [
                (x: CGFloat.random(in: 0.3...0.7), y: CGFloat.random(in: 0.4...0.65)),
                (x: CGFloat.random(in: 0.3...0.7), y: CGFloat.random(in: 0.4...0.65)),
                (x: CGFloat.random(in: 0.3...0.7), y: CGFloat.random(in: 0.4...0.65)),
                (x: CGFloat.random(in: 0.3...0.7), y: CGFloat.random(in: 0.4...0.65))
            ]
            
            withAnimation(.spring(response: 1.5, dampingFraction: 0.8)) {
                rotationAngle = 90
                scale = 1.3
            }
        }
    }   
    
    private func startZoomAnimation(screenSize: CGSize) {
        withAnimation(.easeInOut(duration: 0.8)) {
            floorPlanScale = 3.0
            floorPlanBlur = 50
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            onNavigateToFloorDetail(selectedFloorVideo, floorNumber)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                floorPlanScale = 1.3
                floorPlanBlur = 0
                tappedHotspotIndex = nil
            }
        }
    }
}

