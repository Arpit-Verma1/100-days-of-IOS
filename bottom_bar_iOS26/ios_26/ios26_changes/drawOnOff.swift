//
//  drawOnOff.swift
//  ios_26
//
//  Created by Arpit Verma on 6/24/25.
//

import SwiftUI
struct drawOnOff: View {
    @State private var isActive : Bool = false
    var body: some View {
        Image(systemName: "square.and.arrow.up")
            .font(.largeTitle)
            .foregroundStyle(.white)
            .symbolEffect(.drawOff, isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

#Preview {
    drawOnOff()
}
