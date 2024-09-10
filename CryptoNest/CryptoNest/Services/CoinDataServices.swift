//
//  CoinDataServices.swift
//  CryptoNest
//
//  Created by arpit verma on 09/08/24.
//

import Foundation
import Combine
class CoindDataServices {
    @Published var allCoins : [CoinModel] = []
    
    var coinSubscription : AnyCancellable?
    init() {
        getCoins()
    }
    
     func getCoins() {
        guard let url = URL(string:  "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&sparkline=true&price_change_percentage=24h") else { return }
       
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
            
    }
}
