//
//  HomeView.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortFolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                homeHeader
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
        }
    }
}
#Preview {
    NavigationView {
        HomeView()
    }.navigationBarHidden(true)
}

extension HomeView {
    private var homeHeader :some View{
        HStack{
            CircleButtonView(iconName: showPortFolio ? "plus" : "info").animation(.none
            ).background(
                CircleButtonAnimationView(animate: $showPortFolio)
            )
            Spacer()
            Text(showPortFolio ? "Portfolio": "Live Prices").animation(.none).font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            
            CircleButtonView(iconName: "chevron.right").rotationEffect(Angle(degrees: showPortFolio ? 180 : 0)).onTapGesture {
                withAnimation(.spring()){
                    showPortFolio.toggle()
                }
            }
            
        }.padding(.horizontal)
    
        
        
    }
}

