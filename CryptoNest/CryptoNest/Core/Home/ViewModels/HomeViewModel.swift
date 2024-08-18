//
//  HomeViewModel.swift
//  CryptoNest
//
//  Created by arpit verma on 08/08/24.
//

import Foundation
import Combine

class HomeViewModel :ObservableObject {
    @Published var statistics: [StatisticModel] = [
        ]
        
    @Published var AllCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    private let coinDataService = CoindDataServices()
    private let marketDataService = MarketDataServices()
    private let portfolioDataService = PortfolioDataService()
    private var cancallables = Set<AnyCancellable>()
    
    
    
    init ()  {
        addSubscribers()
    }
    
    func addSubscribers(){
        $searchText.combineLatest(coinDataService.$allCoins)
            .map(filterCoins)
            .sink {[weak self] (returnedCoins) in
                self?.AllCoins = returnedCoins
               
            }
        
            .store(in: &cancallables)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }.store(in: &cancallables)
        
        
        $AllCoins.combineLatest(portfolioDataService.$savedEntities).map {
            (coinModels, portfolioEntities) -> [CoinModel] in
            coinModels.compactMap {
                (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
        }
        .sink{
            [weak self] (returnedCoins) in
            self?.portfolioCoins = returnedCoins
        }
        .store(in : &cancallables)
        
    }
    
    
    
    func updatePortfolio(coin : CoinModel, amount:Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text:String,coins:[CoinModel])->[CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData (marketDataModel: MarketDataModel?) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "MarketCap", value: data.marketCap, percentageChange: data.marketCapChangePerCentage24HUsd)
        let volume = StatisticModel(title: "Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
