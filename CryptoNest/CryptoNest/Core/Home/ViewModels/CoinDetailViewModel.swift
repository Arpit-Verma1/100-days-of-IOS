//
//  CoinDetailViewModel.swift
//  CryptoNest
//
//  Created by arpit verma on 25/08/24.
//

import Foundation
import Combine

class DetailViewModel :ObservableObject{
    @Published var  coin : CoinModel
    
    @Published var overviewStatisics: [StatisticModel] = []
    @Published var additionalStatisics: [StatisticModel] = []
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init (coin :CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDetailService.$coinDetails
        .combineLatest($coin)
        .map(mapDataToStatistic)
        .sink { [weak self] (returnedArrays) in
            self?.overviewStatisics = returnedArrays.overview
            self?.additionalStatisics = returnedArrays.additional
                
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistic (coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview:[StatisticModel], additional:[StatisticModel]){
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
    
          return (overview: overviewArray, additional: additionalArray)
    }
    
    private func createOverviewArray(coinModel : CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWithDecials()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price,percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviation() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviation() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray = [priceStat, marketCapStat, rankStat, volumeStat]
        return overviewArray
    }
    
    private func createAdditionalArray (coinModel: CoinModel, coinDetailModel: CoinDetailModel?) ->[StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWithDecials() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWithDecials() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let low = coinModel.low24H?.asCurrencyWithDecials() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviation() ?? "")
        let marketCapCahnge2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "Market Cap Change", value: marketCapChange ,percentageChange: marketCapCahnge2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray = [highStat, priceChangeStat, lowStat, marketCapChangeStat, blockStat, hashingStat]
        return additionalArray
    }
}
