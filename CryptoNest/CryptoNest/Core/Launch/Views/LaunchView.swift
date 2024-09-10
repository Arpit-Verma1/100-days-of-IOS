//
//  LaunchView.swift
//  CryptoNest
//
//  Created by arpit verma on 08/09/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText : [String] = "Loading Your portfolio...".map {String($0)}
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1 , on: .main , in:.common).autoconnect()
    
    @State private var counter:  Int = 0
    @State private var loops : Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack{
            Color.lauch.background.ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width:100,height: 100)
            
            ZStack{
                if showLoadingText {
                    HStack(spacing:0){
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.system(.headline))
                                .foregroundColor(Color.lauch.accent)
                                .offset(y: counter == index ? -10 : 0)
                        }
                    }.transition(AnyTransition.scale.animation(.easeIn))
                }
                
            }.offset(y:70)
        }.onAppear {
            showLoadingText.toggle()
        }.onReceive(timer, perform: { _ in
            withAnimation(.spring()){
                let lastIndex = loadingText.count - 1
                if lastIndex == loadingText.count - 1 {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
    
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
