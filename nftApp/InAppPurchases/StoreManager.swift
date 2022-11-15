//
//  StoreManager.swift
//  EngageTimer2
//
//  Created by Adam Reed on 1/7/22.
//

import Foundation
import StoreKit
import SwiftUI

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var myProducts = [SKProduct]()
    @Published var myConsumableProducts = [SKProduct]()
    var request: SKProductsRequest!
    @Published var transactionState: SKPaymentTransactionState?
    
    
    
    @Published var game:GameModel = GameModel()
 
    // If not simulator, run ads as normal
    @Published var purchasedRemoveAds = UserDefaults.standard.bool(forKey: "purchasedRemoveAds") {
        didSet {
            UserDefaults.standard.setValue(self.purchasedRemoveAds, forKey: "purchasedRemoveAds")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    if fetchedProduct.localizedTitle == "Remove Advertising" {
                        self.myProducts.append(fetchedProduct)
                    } else {
                        self.myConsumableProducts.append(fetchedProduct)
                        print("price int value: \(fetchedProduct.price.intValue)")
                    }
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .purchased
                print("Tranaction description \(transaction.payment.productIdentifier)")
                
                // With succesfull purchase, do the correct thing per purchase
                // Remove Ads
                if transaction.payment.productIdentifier == "cryptoRemoveAds" {
                    purchasedRemoveAds = true
                }
                
                // Purchase additional monies
                if transaction.payment.productIdentifier == "design.rdconcepts.purchaseOneThousand" {
                    print("Add game money")
                    game.gameDollars += 1000
                    print(self.game.gameDollars.asCurrencyWith2Decimals())
                    
                }
                if transaction.payment.productIdentifier == "design.rdconcepts.crypto.fiveThousand" {
                    print("Add game money")
                    game.gameDollars += 5000
                    print(self.game.gameDollars.asCurrencyWith2Decimals())
                }
                if transaction.payment.productIdentifier == "design.rdconcepts.crypto.tenThousand" {
                    print("Add game money")
                    game.gameDollars += 10000
                    print(self.game.gameDollars.asCurrencyWith2Decimals())
                }
                if transaction.payment.productIdentifier == "design.rdconepts.crypto.fifteenThousand" {
                    print("Add game money")
                    game.gameDollars += 15000
                    print(self.game.gameDollars.asCurrencyWith2Decimals())
                }
                if transaction.payment.productIdentifier == "design.rdconcepts.crypto.twentyFiveThousand" {
                    print("Add game money")
                    game.gameDollars += 25000
                    print(self.game.gameDollars.asCurrencyWith2Decimals())
                }
                if transaction.payment.productIdentifier == "design.rdconcepts.crypto.oneHundredThousand" {
                    print("Add game money")
                    game.gameDollars += 100000
                    print(self.game.gameDollars.asCurrencyWith2Decimals())
                }
               
            case .restored:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .restored
                
                purchasedRemoveAds = true
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                    queue.finishTransaction(transaction)
                    transactionState = .failed
                    default:
                    queue.finishTransaction(transaction)
            }
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            
        } else {
            print("User can't make payment.")
        }
    }
    
    
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
}


