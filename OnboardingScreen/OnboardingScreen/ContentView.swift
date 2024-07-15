//
//  ContentView.swift
//  OnboardingScreen
//
//  Created by arpit verma on 15/07/24.
//

import SwiftUI
import ConcentricOnboarding
struct ContentView: View {
    var body: some View {
        ConcentricOnboardingView(
            pageContents: [(
                view: OnboardingPage(
                    title: "Home",
                    message: "Welcome Back",
                    image: "house"
                ),
                background: .red
            ),
                           (
                            view: OnboardingPage(
                                title: "Feed",
                                message: "Stay up to Date",
                                image: "bell"
                            ),
                            background: .purple
                           ),
                           (
                            view: OnboardingPage(
                                title: "Chat",
                                message: "Chat with Friends",
                                image: "message"
                            ),
                            background: .orange
                           )]
        )
    }
}
struct OnboardingPage :View{
    var title:String
    var message: String
    var image: String
    var body :some View{
        VStack(content: {
            Spacer()
            Text(
                title
            ).font(
                .system(
                    size: 40
                )
            ).bold().foregroundColor(
                .white
            ) 
            
            
            Image(
                systemName: image
            ).resizable().frame(
                width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
                height: 100
            ).foregroundColor(
                .white
            )
           
            Text(
                message
            ).font(
                .system(
                    size: 30
                )
            ).bold().foregroundColor(
                .white
            ) 
            Spacer()
        })
    }
}

#Preview {
    ContentView()
}
