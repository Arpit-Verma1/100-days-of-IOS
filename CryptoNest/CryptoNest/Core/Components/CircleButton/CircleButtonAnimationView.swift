//
//  CircleButtonAnimationView.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding  var animate: Bool
    var body: some View {
        Circle().stroke(lineWidth: 10)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 5.0) : .none)
            .onAppear{
                animate.toggle()
            }
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false)
    ).foregroundColor(.red).frame(
    width: 150, height: 150)
}
