//
//  DetailViewModel.swift
//  nftApp
//
//  Created by Adam Reed on 1/20/22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = []

    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil

    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    
    
}

private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel]) {
    // OverView
    let overviewArray = mapDataToOverview(coinModel: coinModel)
    // Additional
    let additionalArray = mapDataToAdditional(coinModel: coinModel, coinDetailModel: coinDetailModel)
    
    return (overviewArray, additionalArray)
}


private func mapDataToOverview(coinModel: CoinModel) -> [StatisticsModel] {
    
    let price = coinModel.currentPrice.asCurrencyWith6Decimals()
    let pricePercentChange = coinModel.priceChangePercentage24H
    let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChanged: pricePercentChange)
    
    let marketCap = "$" + (coinModel.marketCap?.formattedwithAbbreviations() ?? "")
    let marketCapPercentChange = coinModel.marketCapChangePercentage24H
    let marketCapStat = StatisticsModel(title: "Market Cap Utilization", value: marketCap, percentageChanged: marketCapPercentChange)
    
    let rank = "\(coinModel.rank)"
    let rankStat = StatisticsModel(title: "rank", value: rank)
    
    let volume = "$" + (coinModel.totalVolume?.formattedwithAbbreviations() ?? "")
    let volumeStat = StatisticsModel(title: "Volume", value: volume)
    
    let overviewArray: [StatisticsModel] = [
        priceStat,
        marketCapStat,
        rankStat,
        volumeStat
    ]
    
    return overviewArray
}

private func mapDataToAdditional(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticsModel] {
    let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let highStat = StatisticsModel(title: "24h High", value: high)
    
    let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let lowStat = StatisticsModel(title: "24h Low", value: low)
    
    let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
    let pricePercentChange = coinModel.priceChangePercentage24H
    let priceChangeStat = StatisticsModel(title: "24h Price Change", value: priceChange, percentageChanged: pricePercentChange)
    
    let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedwithAbbreviations() ?? "")
    let marketCapPercentChange = coinModel.marketCapChangePercentage24H
    let marketCapChangeStat = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChanged: marketCapPercentChange)
    
    
    let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
    let blockTimeString = (blockTime == 0 ? "N/A" : "\(blockTime)")
    let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)
    
    let hashing = coinDetailModel?.hashingAlgorithm ?? ""
    let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)
    
    let additionalArray: [StatisticsModel] = [
        highStat,
        lowStat,
        priceChangeStat,
        marketCapChangeStat,
        blockStat,
        hashingStat
    ]
    
    return additionalArray
}
