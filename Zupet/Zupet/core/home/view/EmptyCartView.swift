//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI

struct EmptyCartView: View {
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image("emptyCart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .clipShape(.circle)
                .scaleEffect(animate ? 1 : 0.7)
                .opacity(animate ? 1 : 0)
                .animation(
                    .spring(response: 0.7, dampingFraction: 0.8),
                    value: animate
                )
            
            VStack {
                Text("Adopt and adore")
                    .font(.custom("HollaBear-Regular", size: 24))
                Text("Come on lets join us and adopt pets you like")
                    .font(.typography.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.theme.subTitleTexColor)
                    .frame(width: 300)
            }
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 12)
            .animation(
                .spring(response: 0.6, dampingFraction: 0.85)
                    .delay(0.1),
                value: animate
            )
            
            Button(action: {}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 35, style: .continuous)
                        .fill(Color.theme.textColor)
                        .offset(x: 2, y: 2)
                    
                    RoundedRectangle(cornerRadius: 35, style: .continuous)
                        .fill(Color.theme.petStripe2)
                    
                    Text("Explore")
                        .font(Font.typography.headlineBold)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 60)
            .frame(width: 200)
            .buttonStyle(.plain)
            .scaleEffect(animate ? 1 : 0.8)
            .opacity(animate ? 1 : 0)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.85)
                    .delay(0.2),
                value: animate
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.backgroundColor.ignoresSafeArea())
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    EmptyCartView()
}
