//
//  DetailView.swift
//  CryptoNest
//
//  Created by arpit verma on 25/08/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin : CoinModel?
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
                
            }
        }
    }
}

struct DetailView: View {
    @StateObject var vm : DetailViewModel
    
    @State private var showFullDescription : Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing : CGFloat = 30
    
    
    init(coin : CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartsView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing:10){
                    
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                    websitSection
                }
                .padding()
            }
            
            
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(vm.coin.name)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarTrailingItems
                }
            }
    }
}

struct DetailView_Preview : PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}

extension DetailView {
    
    private var navigationBarTrailingItems : some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .bold()
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity ,alignment: .leading)
    }
    
    private var additionalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity ,alignment: .leading)
    }
    
    private var descriptionSection : some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        showFullDescription.toggle()
                    }
                }, label: {
                    Text(showFullDescription ? "Read less..." : "Read more...")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                        .padding(.vertical,  4)
                    
                }).frame(maxWidth: .infinity, alignment: .leading)
            }
                
            }
            
        }
    }
    
    private var overviewGrid : some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.overviewStatisics) {
                stat in
                StatisticView(stat:  stat)
            }
            
        }
                  
        )
    }
    
    private var additionalGrid :some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.additionalStatisics) {
                stat in
                StatisticView(stat:  stat)
            }
            
        }
                  
        )
    }
    
    
    private var websitSection : some View {
        VStack(alignment: .leading,spacing: 20) {
            if let website = vm.websiteUrl,
               let url = URL(string: website) {
                Link("Website", destination: url)
            }
            if let redditUrl = vm.redditUrl,
               let url = URL(string: redditUrl) {
                Link("Reddit", destination: url)
            }
        }.accentColor(.blue).frame(maxWidth: .infinity, alignment: .leading).font(.headline
        )
    }
}
