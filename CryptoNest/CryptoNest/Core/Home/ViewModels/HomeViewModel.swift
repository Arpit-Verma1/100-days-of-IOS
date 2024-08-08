//
//  HomeViewModel.swift
//  CryptoNest
//
//  Created by arpit verma on 08/08/24.
//

import Foundation
class HomeViewModel :ObservableObject {
    @Published var AllCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    init ()  {
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0 ) {
            self.AllCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
    
}
