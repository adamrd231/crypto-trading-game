//
//  GameDataSevice.swift
//  nftApp
//
//  Created by Adam Reed on 1/26/22.
//

import Foundation
import CoreData

//class GameDataService {
//
//    private let container: NSPersistentContainer
//    private let containerName: String = "PortfolioContainer"
//    private let entityName: String = "TradeEntity"
//    
//    @Published var savedTradeEntities: [TradeEntity] = []
//
//    init() {
//        container = NSPersistentContainer(name: containerName)
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                print(
//                    """
//                    Error loading core data:
//                    \(error)
//                    """
//                )
//            }
//            self.getTrades()
//        }
//
//
//    }
//
//    func createTrade() {
//        let newTrade = TradeEntity(context: container.viewContext)
//        newTrade.money = 100
//        newTrade.dateOfTrade = Date()
//        newTrade.priceOfCrypto = 1.0
//
//        save()
//        getTrades()
//    }
//
//    private func getTrades() {
//        let request = NSFetchRequest<TradeEntity>(entityName: entityName)
//        do {
//            try container.viewContext.fetch(request)
//        } catch let error {
//            print("Error Fetching Portfolio: \(error)")
//        }
//    }
//
//    func addTrade(trade: GameTrade, amount: Double) {
//        let entity = TradeEntity(context: container.viewContext)
//        entity.money = trade.money
//        entity.priceOfCrypto = trade.priceOfCrypto
//        entity.dateOfTrade = Date()
//        print("Converting trade object to trade entity")
//        save()
//        applyChanges()
//    }
//
//    private func save() {
//        do {
//            print("Attempting to save data")
//            try container.viewContext.save()
//
//        } catch let error {
//            print("Error saving to Core Data. \(error)")
//        }
//    }
//
//
//    private func applyChanges() {
//        save()
//        getTrades()
//    }
//
//
//}
