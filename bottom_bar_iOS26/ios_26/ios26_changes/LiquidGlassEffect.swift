//
//  ContentView.swift
//  bottom_bar_iOS26
//
//  Created by Arpit Verma on 22/06/25.
//

import SwiftUI

struct LiquidGlassEffect: View {
    
    @State private var isExpanded: Bool = false
    @Namespace private var animation
    var body: some View {
       
        ZStack {
//            Image("Pic")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 300, height:  300)
//                .clipShape(.rect(cornerRadius: 20))
//            
//            
//            if #available(iOS 26.0, *) {
//                Image(systemName: "suit.heart.fill")
//                    .font(.title)
//                    .foregroundStyle(.red.gradient)
//                    .frame(width: 50, height: 50)
//                    .glassEffect(.regular.tint(.red.opacity(0.35)).interactive(), in: .circle)
//            } else {
//                // Fallback on earlier versions
//            }
            
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height:  300)
                .clipShape(.rect(cornerRadius: 20))
                .overlay(alignment: .bottom) {
                        GlassEffectContainer(spacing: 20) {
                            VStack(spacing: 20){
                                Spacer()
                                if isExpanded {
                                    Group{
                                        Image(systemName: "suit.heart.fill")
                                            .font(.title)
                                            .foregroundStyle(.red.gradient)
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: "magnifyingglass")
                                            .font(.title)
                                            .foregroundStyle(.red.gradient)
                                            .frame(width: 50, height: 50)
                                    }
//                                    .glassEffect(.regular, in: .circle) // glass effect seperate
//                                    .glassEffectTransition(.identity) // glass effect not to show animation
                                    .glassEffect(.regular, in: .capsule) //  Glass Effect Combine Two Views
                                    .glassEffectUnion(id: "Group-1", namespace: animation)
                                    
                                }
                                
                                Button {
                                    withAnimation(.smooth(duration: 1, extraBounce: 0)) {
                                        isExpanded.toggle()
                                    }
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.title)
                                        .foregroundStyle(.white.gradient)
                                        .frame(width: 50, height: 50)
                                }.buttonStyle(.glass)
                            }.padding(15)
                            
                        }
                
                }
            
            
            
            
            
            
        }
            
    }
}


#Preview {
    LiquidGlassEffect()
}
