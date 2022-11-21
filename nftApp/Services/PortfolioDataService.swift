//
//  PortfolioDataService.swift
//  nftApp
//
//  Created by Adam Reed on 1/18/22.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    private let tradeEntityName: String = "TradeEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    @Published var savedTradeEntities: [TradeEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(
                    """
                    Error loading core data:
                    \(error)
                    """
                )
            }
            self.getPortfolio()
            self.getTrades()
        }
    }
    
    func getTrades() {
        let request = NSFetchRequest<TradeEntity>(entityName: tradeEntityName)
        
        do {
            savedTradeEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Portfolio: \(error)")
        }
    }
    
    // MARK: Public
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // Check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.id == coin.id }) {
            let newValue = entity.amount + amount
            // Updating amount
            if newValue > 0 {
                update(entity: entity, amount: newValue)
            } else {
                // Deleting amount
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    func saveCryptoCoinSale(coin: CoinModel, amountOfCryptoSold: Double) {
        let trade = TradeEntity(context: container.viewContext)
        trade.type = "Sale"
        trade.cryptoName = coin.name
        trade.dateOfTrade = Date()
        trade.money = amountOfCryptoSold * coin.currentPrice
        trade.cryptoCoinAmount = amountOfCryptoSold
        trade.priceOfCrypto = coin.currentPrice
        applyChanges()
    }
    
    func saveCryptoCoinPurchase(coin: CoinModel, amountOfMoneySpent: Double) {
        let trade = TradeEntity(context: container.viewContext)
        trade.type = "Purchase"
        trade.cryptoName = coin.name
        trade.dateOfTrade = Date()
        trade.money = amountOfMoneySpent
        trade.priceOfCrypto = coin.currentPrice
        trade.cryptoCoinAmount = (1 / coin.currentPrice) * amountOfMoneySpent
        print("adding coin")
        add(coin: coin, amount: amountOfMoneySpent)
        applyChanges()
    }
    
    
    // MARK: Private
    func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print(
                """
                Error fetching Portfolio Entries:
                \(error)
                """
            )
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.id = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func addTrade(coin: CoinModel, amount: Double) {
        let entity = TradeEntity(context: container.viewContext)
        entity.dateOfTrade = Date()
        entity.money = amount
        entity.priceOfCrypto = coin.currentPrice
        
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func deleteTradeEntity(entity: TradeEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    func deleteAllPortfolioEntities() {
        for entity in savedEntities {
            delete(entity: entity)
        }
    }
    
    func deleteAllTradeEntities() {
        for entity in savedTradeEntities {
            deleteTradeEntity(entity: entity)
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
            
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    
    func applyChanges() {
        save()
        getPortfolio()
        getTrades()
    }
}
