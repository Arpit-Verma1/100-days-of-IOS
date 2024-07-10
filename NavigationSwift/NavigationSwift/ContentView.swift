//
//  ContentView.swift
//  NavigationSwift
//
//  Created by arpit verma on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Day 1 of my iOS Learning Journey!")
                    .font(.headline)
                    .padding()

                NavigationLink(destination: DetailView()) {
                    Text("Go to Detail View")
                        .font(.subheadline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("This is the Detail View!")
            .font(.largeTitle)
            .padding()
            .navigationTitle("Detail")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
