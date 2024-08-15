//
//  CoinImgeViewModel.swift
//  CryptoNest
//
//  Created by arpit verma on 11/08/24.
//

import Foundation
import SwiftUI
import  Combine
class CoinImageViewModel : ObservableObject {
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    
    private let coin:  CoinModel
    private let dataService : CoinImageService
    private var cancellables = Set<AnyCancellable>()
   
    init(coin:CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin )
        self.addSubscribers()
        self.isLoading = true;
     
    }
    
    private func addSubscribers() {
        dataService.$image.sink {
            [weak self] (_) in
            self?.isLoading  = false
        }receiveValue: { [weak self] returnedImage in
            self?.image = returnedImage
            self?.isLoading = false
        }.store(in: &cancellables)
        
    }
}
