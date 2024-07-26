//
//  ContentView.swift
//  UrlLauncher
//
//  Created by arpit verma on 22/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Link(destination: URL(string: "https://www.goggle.com")!, label: {
                
                Label(
                    title: { Text("Search Goggle").bold() },
                    icon: { Image(systemName: "magnifyingglass").font(.system(size: 22,weight: .bold,design: .default)) }
                ).frame(
                    width:250,
                    height: 50
                ).background(Color.blue)
                    .foregroundColor(.white).cornerRadius(10)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
