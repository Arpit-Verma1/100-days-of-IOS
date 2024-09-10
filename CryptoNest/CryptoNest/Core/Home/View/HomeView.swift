//
//  HomeView.swift
//  CryptoNest
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortFolio: Bool = true
    @State private var showPortfolioView: Bool = false
    @State private var showSettingView : Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView : Bool = false
    
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
                    ZStack {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            portfolioEmptyText
                        }
                        else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .sheet(isPresented: $showSettingView, content: {
                SettingView()
            })
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive:$showDetailView, label: {
                EmptyView()
            })
        )
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
                else
                {
                    showSettingView.toggle()
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
                CoinRowView(coin: coin, showHodingCoulumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }.listRowBackground(Color.theme.background)
                
            }
        }.listStyle(PlainListStyle())
    }
    
    
    private var portfolioCoinsList : some  View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHodingCoulumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }.listRowBackground(Color.theme.background)
            }
        }.listStyle(PlainListStyle())
    }
    private var portfolioEmptyText : some View {
        Text("You have no coins in your portfolio.\nAdd a coin by tapping the + button on the top right.")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private func segue(coin : CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    
    private var columnTitles : some View {
        HStack {
            HStack{
                Text("Coin")
                Image(systemName : "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
                
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
                
            }
            
            Spacer()
            if showPortFolio {
                HStack{
                    Text("Holdings")
                    Image(systemName : "chevron.down") .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }.onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdingsReversed
                    }
                    
                }
                
            }
            HStack{
                Text("Price")
                Image(systemName : "chevron.down") .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
                
            }.onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed: .price
                }
                
            }
            
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
            Button(action :{
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            },
                   label: {
                Image(systemName: "goforward")
            }
            ).rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0),anchor: .center)
            
        }.padding()
    }
}

