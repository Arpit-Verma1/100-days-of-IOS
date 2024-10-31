//
//  SliderBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct SliderBootCamp: View {
    @State var sliderValue : Double = 2.0
    var body: some View {
        VStack {
            Text(String(format: "%.0f", sliderValue))
            Slider(value: $sliderValue,
                   in: 1...5,
                   step: 1.0,
                   label: {Text("slider")},
                   minimumValueLabel: {Text("1")},
                   maximumValueLabel: {Text("5")})
        }
    }
}

#Preview {
    SliderBootCamp()
}
