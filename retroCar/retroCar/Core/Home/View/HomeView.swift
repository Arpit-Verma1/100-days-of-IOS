//
//  HomeView.swift
//  retroCar
//
//  Created by Arpit Verma on 12/25/25.
//

import SwiftUI
import AVKit
import AVFoundation

struct HomeView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var showVideo: Bool = false
    @State private var circleScale: CGFloat = 1.0
    @State private var textOpacity: Double = 1.0
    @State private var selectedYear: YearModel? = nil
    @Namespace private var heroAnimation
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.theme.backgrounColor.ignoresSafeArea()
                let screenCenter = geometry.size.width / 2 - 50
            
                if selectedYear == nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: 00) {
                            ForEach(years) { card in
                                
                                GeometryReader { geo in
                                    let cardCenter = geo.frame(in: .global).midX
                                    let distance = abs(cardCenter - screenCenter)
                                    let progress = min(distance / screenCenter, 1)
                                    
                                    let minHeight: CGFloat = 660
                                    let maxHeight: CGFloat = 760
                                    let height = maxHeight - (progress * (maxHeight - minHeight))
                                    VStack(alignment: .center) {
                                        Spacer()
                                            .frame(height: (maxHeight-height)/2)
                                        YearCardView(yearModel: card, namespace: heroAnimation)
                                            .frame(width: 170, height: height, alignment: .center)
                                            .animation(.easeOut(duration: 0.25), value: height)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 1, dampingFraction: 1)) {
                                                    selectedYear = card
                                                }
                                            }
                                    }
                                }
                                .frame(width: 180,height : 760)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, 20, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .opacity(isAnimating ? 0 : 1)
                }
                
                if !showVideo && selectedYear == nil {
                    viewStoryView(geometry: geometry)
                }
                
                if showVideo {
                    VideoPlayerView(
                        showVideo: $showVideo,
                        isAnimating: $isAnimating,
                        circleScale: $circleScale,
                        textOpacity: $textOpacity
                    )
                    .transition(.opacity)
                }
                
                if let selectedYear = selectedYear {
                    YearCardDetailView(
                        yearModel: selectedYear,
                        allYears: years,
                        namespace: heroAnimation,
                        onDismiss: {
                            withAnimation(.spring(response: 1, dampingFraction: 1)) {
                                self.selectedYear = nil
                            }
                        }
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .background(Color.theme.backgrounColor)
        }
    }
    
    private func startAnimation(screenSize: CGSize) {
        let circleRadius: CGFloat = 65
        let diagonal = sqrt(screenSize.width * screenSize.width + screenSize.height * screenSize.height)
        let maxScale = (diagonal / circleRadius) + 1.0
        
        withAnimation(.easeInOut(duration: 0.8)) {
            circleScale = maxScale
            textOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isAnimating = true
            showVideo = true
        }
    }
    
    @ViewBuilder
    func viewStoryView(geometry: GeometryProxy ) -> some View {
        HStack(alignment: .center) {
            Text("VIEW STORY")
                .font(Font.custom("rolf", size: 20))
            Image(systemName: "arrow.right")
                .resizable()
                .frame(width: 25, height: 25)
        }
        .foregroundColor(Color(hex: "#b42133"))
        .opacity(textOpacity)
        .frame(width: 130, height: 130)
        .background(
            Circle()
                .fill(Color.theme.backgrounColor)
                .scaleEffect(circleScale)
        )
        .onTapGesture {
            startAnimation(screenSize: geometry.size)
        }
    }
}


#Preview {
    HomeView()
}

