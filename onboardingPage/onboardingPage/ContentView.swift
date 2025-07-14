//
//  ContentView.swift
//  onboardingPage
//
//  Created by Arpit Verma on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding  : Bool = true
    var body: some View {
        NavigationStack {
            List {
                
            }.navigationTitle("Apple Games")
        }
        .sheet(isPresented: $showOnboarding) {
            AppleOnboardingView(tint: .red, title: "Welcome to Apple Games") {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 30))
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .background(.red.gradient, in : .rect(cornerRadius: 25))
                    .frame(height: 100)
                
                
                
                
            } cards: {
             AppleOnboardingCard(symbol: "list.bullet",
                                 title: "See what's new her for you",
                                 subtitle: "Explore what happing with your games and what to have next"
             )
                
                
                AppleOnboardingCard(symbol: "person.2",
                                    title: "Play and compete with frients",
                                    subtitle: "Challenge frds and see what they are doing"
                )
                
                AppleOnboardingCard(symbol: "person.2",
                                    title: "Play and compete with frients",
                                    subtitle: "Challenge frds and see what they are doing"
                )
                
                
                
                
            } footer: {
                
                VStack (alignment: .leading,spacing: 6) {
                    Image(systemName: "person.3.fill")
                        .foregroundStyle(.red)
                    Text("Your game play activity incude what you play and hwo you playe")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                }
                
            } onContinue: {
                showOnboarding = false
            }

        }
    }
}

#Preview {
    ContentView()
}
