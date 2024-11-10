//
//  RotationGestureBootCamp.swift
//  SwiftIntermediateBootCamp
//
//  Created by Arpit Verma on 08/11/24.
//

import SwiftUI

struct RotationGestureBootCamp: View {
    @State var angle: Angle = Angle(degrees: 0)
    var body: some View {
        Text("Hello World")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(50)
            .background(Color.blue.cornerRadius(15))
            .rotationEffect(angle)
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        angle = value
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            angle = Angle(degrees: 0)
                        }
                    }
            )
    }
}

#Preview {
    RotationGestureBootCamp()
}

