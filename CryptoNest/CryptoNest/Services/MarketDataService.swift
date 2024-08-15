//
//  MarketDataService.swift
//  CryptoNest
//
//  Created by arpit verma on 15/08/24.
//

import Foundation
import Combine
class MarketDataServices {
    @Published var marketData : MarketDataModel? = nil
    
    var marketDataSubscription : AnyCancellable?
    init() {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string:  "https://api.coingecko.com/api/v3/global") else { return }
       
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
            
    }
}
