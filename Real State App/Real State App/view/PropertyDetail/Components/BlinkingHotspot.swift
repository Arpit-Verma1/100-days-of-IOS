//
//  BlinkingHotspot.swift
//  Real State App
//
//  Created by Arpit Verma on 1/14/26.
//

import SwiftUI

struct BlinkingHotspot: View {
    let delay: Double
    var onTap: () -> Void = {}
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Outer pulsing circle
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .scaleEffect(pulseScale)
                    .opacity(isAnimating ? 0.0 : 0.6)
                
                // Inner dot
                Circle()
                    .fill(Color.black)
                    .frame(width: 12, height: 12)
                    .opacity(isAnimating ? 1.0 : 0.7)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(
                    Animation
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimating.toggle()
                    pulseScale = 1.3
                }
            }
        }
    }
}

