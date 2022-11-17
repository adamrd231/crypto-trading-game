//
//  HomeViewModel.swift
//  nftApp
//
//  Created by Adam Reed on 1/13/22.
//

import Foundation
import Combine
import SwiftUI
import StoreKit

class HomeViewModel: ObservableObject {
    
    // Data Model Variables
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var allTrades: [GameTrade] = []
    
    // User Statistics model
    @Published var PortfolioStats: [StatisticsModel] = []
    @Published var Portfolio24Change: Double = 0
    
    
    // Data for creating statistics layouts
    @Published var statistics: [StatisticsModel] = []
    @Published var secondRowStatistics: [StatisticsModel] = []
    
    // Screen navigation
    @Published var isLoading: Bool = false
    
    // Current Search Text
    @Published var searchText: String = ""
    
    // Options for sorting data
    @Published var sortOption: SortOption = .holdings
    
    // Data Services
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    let portfolioDataService = PortfolioDataService()

    private var cancellables = Set<AnyCancellable>()
    @State var totalSpentInTrades: Double = 0
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    
   // MARK: Store Manager
    @Published var storeManager: StoreManager = StoreManager()
    
    private func setupStoreManager() {
        if storeManager.myProducts.isEmpty {
            SKPaymentQueue.default().add(storeManager)
            storeManager.getProducts(productIDs: productIDs)
        }
    }
    
    var productIDs = [
        "cryptoRemoveAds",
        "design.rdconcepts.purchaseOneThousand",
        "design.rdconcepts.crypto.fiveThousand",
        "design.rdconcepts.crypto.tenThousand",
        "design.rdconepts.crypto.fifteenThousand",
        "design.rdconcepts.crypto.twentyFiveThousand",
        "design.rdconcepts.crypto.oneHundredThousand",
    ]
    
//    let portfolioValue =
//        portfolioCoins
//            .map({ $0.currentHoldingsValue })
//            .reduce(0, +)
    
    init() {
        addSubscribers()
        setupStoreManager()
    }
    
    func addSubscribers() {
        // Updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortcoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates Portfolio Coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
                
            }
            .store(in: &cancellables)
        
        // Updates the market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins, storeManager.game.$gameDollars)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats.0
                self?.secondRowStatistics = returnedStats.1
                self?.Portfolio24Change = returnedStats.2
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
        // Updates game information
        portfolioDataService.$savedTradeEntities
            .map(mapTradesToArray)
            .sink { returnedTrades in
                self.allTrades = returnedTrades
                self.totalSpentInTrades = self.allTrades.map({ $0.money }).reduce(0, +)
                
            }
            .store(in: &cancellables)

    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel], gameDollars: Double) -> ([StatisticsModel], [StatisticsModel], Double) {
        var stats: [StatisticsModel] = []
        var secondStats: [StatisticsModel] = []
        
        guard let data = marketDataModel else { return (stats, secondStats, 0) }
        
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChanged: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let bitcoinDominance = StatisticsModel(title: "BTC Share", value: data.bitDominance)
        
        let portfolioValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue =
            portfolioCoins
                .map{ (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = (coin.priceChangePercentage24H ?? 0) * 0.01
                    let previousValue = currentValue / (percentChange + 1)
                    return previousValue
                }
                .reduce(0, +)

        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticsModel(
            title: "Crypto Holdings",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChanged: percentageChange
        )
        
        let startingDate = storeManager.game.startingDate
        let startingDateStat = StatisticsModel(title: "Start Date", value: startingDate.asShortDateString())
        let numberOfTrades = allTrades.count
        let numberOfTradesStat = StatisticsModel(title: "# of Trades", value: numberOfTrades.description)
        let totalUSDMoney:Double = gameDollars
        let totalUSDMoneyStat = StatisticsModel(title: "Game Monies", value: totalUSDMoney.asCurrencyWith2Decimals())
        let totalMoneyOverall = portfolioValue + totalUSDMoney
        let totalMoneyOverallStat = StatisticsModel(title: "Total Score", value: totalMoneyOverall.asCurrencyWith2Decimals())
        
        secondStats.append(contentsOf: [
            marketCap,
            startingDateStat,
            numberOfTradesStat,
            
        ])
        
        stats.append(contentsOf: [
            
            totalUSDMoneyStat,
            portfolio,
            totalMoneyOverallStat

        ])
        // selling price substracted from intial purchase price
        let startingPrice = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0,+)
        let purchasePrice = allTrades.map({ $0.priceOfCrypto * $0.cryptoCoinAmount }).reduce(0,+)
        var portfolio24HourChange = ((startingPrice - purchasePrice) / startingPrice) * 100
        return (stats, secondStats, portfolio24HourChange)
    }
    
    private func mapTradesToArray(trades: [TradeEntity]) -> [GameTrade] {
        var createTrades: [GameTrade] = []
        
        for trade in trades {
            var addTrade = GameTrade(type: trade.type ?? "", coinName: trade.cryptoName ?? "", priceOfCrypto: trade.priceOfCrypto, dateOfTrade: trade.dateOfTrade ?? Date(), money: trade.money, cryptoCoinAmount: trade.cryptoCoinAmount)
            createTrades.append(addTrade)
        }
        createTrades.sort(by: {$0.dateOfTrade > $1.dateOfTrade})
        
        return createTrades
    }
    
    func updateForPurchase(coin: CoinModel, amountSpentPurchasingCrypto: Double) {
        portfolioDataService.saveCryptoCoinPurchase(coin: coin, amountOfMoneySpent: amountSpentPurchasingCrypto)
    }
    
    func updateForSale(coin: CoinModel, amountOfCryptoSold: Double) {
        portfolioDataService.saveCryptoCoinSale(coin: coin, amountOfCryptoSold: amountOfCryptoSold)
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
        
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    

    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.id == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    

    
    private func filterAndSortcoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        // sort coins
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
        
        
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
        }
        
    }
    
    
}
