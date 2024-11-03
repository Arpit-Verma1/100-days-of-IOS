//
//  ViewThatfitsBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 03/11/24.
//

import SwiftUI

struct ViewThatfitsBootCamp: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            ViewThatFits {
                Text("This is some text that i would to be fit in box")
                Text("This is some text that i would to be fit ")
                Text("This is some text that i would")
                
            }
        }
        .frame(height: 300)
            .padding(10)
            .font(.headline)
    }
}

#Preview {
    ViewThatfitsBootCamp()
}
