//
//  ContentView.swift
//  Safearea
//
//  Created by arpit verma on 25/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            // background view
            VStack {// forground view
                Text("text start here")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                ForEach(0..<10) {
                    index in RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(height: 150)
                        .shadow(radius: 10)
                        .padding(20)
                    
                }
            }.background(Color.blue)
        }.background(Color.red).ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
