//
//  HomeViewModel.swift
//  CryptoNest
//
//  Created by arpit verma on 08/08/24.
//

import Foundation
import Combine

class HomeViewModel :ObservableObject {
    @Published var AllCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    private let dataService = CoindDataServices()
    private var cancallables = Set<AnyCancellable>()
    
    
    
    init ()  {
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                self?.AllCoins = returnedCoins
               
            }
            .store(in: &cancallables)
    }
    
}
