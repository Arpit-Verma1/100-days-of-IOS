//
//  HomeView.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortFolio: Bool = false
    @State private var showPortfolioView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea().sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView().environmentObject(vm)
                })
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortFolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
               
                if !showPortFolio{
                    allCoinsList.transition(.move(edge: .leading))
                }
                if showPortFolio
                {
                    portfolioCoinsList.transition(.move(edge: .trailing))
                }
                    
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
struct HomeView_Preview : PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }.environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader :some View{
  
        HStack{
            CircleButtonView(iconName: showPortFolio ? "plus" : "info").animation(.none
            ).onTapGesture {
                if showPortFolio {
                    showPortfolioView.toggle()
                }
            }
            .background(
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
    
    
    private var allCoinsList : some  View {
        List {
            ForEach(vm.AllCoins) { coin in
                CoinRowView(coin: coin, showHodingCoulumn: false).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }.listStyle(PlainListStyle())
    }
    private var portfolioCoinsList : some  View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHodingCoulumn: true).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }.listStyle(PlainListStyle())
    }
    private var columnTitles : some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortFolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }.padding()
    }
}

