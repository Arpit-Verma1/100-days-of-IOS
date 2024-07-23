//
//  ContentView.swift
//  LottieAnimation
//
//  Created by arpit verma on 23/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LottieView().frame(
            width: 250,
            height: 250,
            alignment: .center
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
