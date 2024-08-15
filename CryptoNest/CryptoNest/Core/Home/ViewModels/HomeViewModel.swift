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
        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChange: -19)
        ]
        
    @Published var AllCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    private let dataService = CoindDataServices()
    private var cancallables = Set<AnyCancellable>()
    
    
    
    init ()  {
        addSubscribers()
    }
    
    func addSubscribers(){
        $searchText.combineLatest(dataService.$allCoins)
            .map(filterCoins)
            .sink {[weak self] (returnedCoins) in
                self?.AllCoins = returnedCoins
               
            }
            .store(in: &cancallables)
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
    
}
