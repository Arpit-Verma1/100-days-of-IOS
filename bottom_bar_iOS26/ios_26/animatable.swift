//
//  animatable.swift
//  ios_26
//
//  Created by Arpit Verma on 6/24/25.
//

import SwiftUI

struct animatable: View {
    @State private var expand : Bool = false
    var body: some View {
        VStack {
            CircleShape(radius: expand ? 100 : 0)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.smooth ) {
                        expand.toggle()
                        
                    }
                }
            .padding()
        }
    }
}

@Animatable
struct CircleShape : Shape {
     var radius : CGFloat
    func path (in rect : CGRect)-> Path {
        Path {
            path in
            path
                .addArc(center: .init(x: rect.midX, y: rect.midY), radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
        }
    }
}

#Preview {
    animatable()
}
