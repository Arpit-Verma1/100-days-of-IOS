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
            
            VStack(spacing:10){
                Text("")
                    .frame(height: 150)
                overviewTitle
                Divider()
                overviewGrid
                
                
                additionalTitle
                Divider()
                additionalGrid
                
                
            }
            .padding()
        }.navigationTitle(vm.coin.name)
    }
}

struct DetailView_Preview : PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}

extension DetailView {
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
}
