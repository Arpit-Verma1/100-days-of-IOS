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
    @Published var isLoading: Bool = false
    @Published var sortOption : SortOption = .holdings
    private let coinDataService = CoindDataServices()
    private let marketDataService = MarketDataServices()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancallables = Set<AnyCancellable>()
    enum SortOption {
        case rank, rankReversed, price, priceReversed, holdings, holdingsReversed
    }
    
    
    init ()  {
        addSubscribers()
    }
    
    func addSubscribers(){
        $searchText.combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink {[weak self] (returnedCoins) in
                self?.AllCoins = returnedCoins
                
            }
        
            .store(in: &cancallables)
        
        $AllCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink{
                [weak self] (returnedCoins) in
                
                guard let  self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in : &cancallables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }.store(in: &cancallables)
        
    }
    
    
    
    func updatePortfolio(coin : CoinModel, amount:Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManger.notification(type: .success)
        
    }
    
    private func filterAndSortCoins(text:String,coins:[CoinModel], sort: SortOption)->[CoinModel]{
        var filterCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filterCoins)
        return filterCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank,.holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed,.holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
            
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins:[CoinModel])->[CoinModel]{
        switch sortOption {
        case .rank,.rankReversed,.price,.priceReversed:
            return coins
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        }
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
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    
    private func mapGlobalMarketData (marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "MarketCap", value: data.marketCap, percentageChange: data.marketCapChangePerCentage24HUsd)
        let volume = StatisticModel(title: "Volume", value: data.volume)
        
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        let previousValue = portfolioCoins.map{
            (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }.reduce(0,+)
        
        let percentageChange = (previousValue == 0) ? 0 : ((portfolioValue - previousValue) / previousValue)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWithDecials(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
