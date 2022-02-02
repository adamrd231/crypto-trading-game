//
//  TradeHistoryView.swift
//  nftApp
//
//  Created by Adam Reed on 1/30/22.
//

import SwiftUI

struct TradeHistoryView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var pickerSelection:Int = 0
    var pickerStatus = ["All", "Purchases", "Sales"]
    
    
    func getTotalPurchasesSpent() -> Text {
        var total:Double = 0
        
        for trade in vm.allTrades {
            if trade.type == "Purchase" {
                total += trade.money
            }
        }
        return Text(total.asCurrencyWith2Decimals())
    }
    
    func getTotalMoneyFromCryptoSales() -> Text {
        var total:Double = 0
        
        for trade in vm.allTrades {
            if trade.type == "Sale" {
                total += trade.money
            }
        }
        return Text(total.asCurrencyWith2Decimals())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            }
            
            Text("Trades")
                .font(.title)
                .fontWeight(.medium)
            
            HStack {
                Text("Total spent")
                Spacer()
                getTotalPurchasesSpent().font(.subheadline)
            }
            
            HStack {
                Text("Total sold")
                Spacer()
                getTotalMoneyFromCryptoSales().font(.subheadline)
            }
            
            Picker("Filter", selection: $pickerSelection) {
                ForEach(0..<pickerStatus.count) { index in
                    Text("\(pickerStatus[index])")
                }
            }.pickerStyle(SegmentedPickerStyle())
                
            ScrollView {
                if pickerStatus[pickerSelection] == "Purchases" {
                    allPurchaseTrades
                } else if pickerStatus[pickerSelection] == "Sales" {
                    allSalesTrades
                } else {
                    allTrades
                }
                
                
            }
            AdMobBanner()
        }.padding()
    }
}

struct TradeHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TradeHistoryView()
    }
}


extension TradeHistoryView {
    var allSalesTrades: some View {
        ForEach(vm.allTrades) { trade in
            if trade.type == "Sale" {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Type")
                        Spacer()
                        Text("\(trade.type)").font(.footnote)
                    }
                    HStack {
                        Text("Coin")
                        Spacer()
                        Text("\(trade.coinName)").font(.subheadline)
                    }
                    HStack {
                        Text("Date:")
                        Spacer()
                        Text("\(trade.dateOfTrade.asLongDateString())").font(.subheadline)
                    }
                    HStack {
                        Text("Price of Crypto Coin:")
                        Spacer()
                        Text(" \(trade.priceOfCrypto.asCurrencyWith6Decimals())").font(.subheadline)
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Spent" : "Earned")
                        Spacer()
                        Text("\(trade.money.asCurrencyWith2Decimals())").font(.subheadline)
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Bought Coins" : "Sold Coins")
                        Spacer()
                        Text("\(trade.cryptoCoinAmount.asNumberStringWithSixDecimals())").font(.subheadline)
                    }
                }
                Divider()
            }
        }
    }
    
    var allTrades: some View {
        ForEach(vm.allTrades) { trade in
            VStack(alignment: .leading) {
                HStack {
                    Text("Type")
                    Spacer()
                    Text("\(trade.type)").font(.footnote)
                }
                HStack {
                    Text("Coin")
                    Spacer()
                    Text("\(trade.coinName)").font(.subheadline)
                }
                HStack {
                    Text("Date:")
                    Spacer()
                    Text("\(trade.dateOfTrade.asShortDateString())").font(.subheadline)
                }
                HStack {
                    Text("Price of Crypto Coin:")
                    Spacer()
                    Text(" \(trade.priceOfCrypto.asCurrencyWith6Decimals())").font(.subheadline)
                }
                HStack {
                    Text(trade.type == "Purchase" ? "Spent" : "Earned")
                    Spacer()
                    Text("\(trade.money.asCurrencyWith2Decimals())").font(.subheadline)
                }
                HStack {
                    Text(trade.type == "Purchase" ? "Bought Coins" : "Sold Coins")
                    Spacer()
                    Text("\(trade.cryptoCoinAmount.asNumberStringWithSixDecimals())").font(.subheadline)
                }
            }
            Divider()

        }
    }
    
    var allPurchaseTrades: some View {
        ForEach(vm.allTrades) { trade in
            if trade.type == "Purchase" {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Type")
                        Spacer()
                        Text("\(trade.type)").font(.footnote)
                    }
                    HStack {
                        Text("Coin")
                        Spacer()
                        Text("\(trade.coinName)").font(.subheadline)
                    }
                    HStack {
                        Text("Date:")
                        Spacer()
                        Text("\(trade.dateOfTrade.asShortDateString())").font(.subheadline)
                    }
                    HStack {
                        Text("Price of Crypto Coin:")
                        Spacer()
                        Text(" \(trade.priceOfCrypto.asCurrencyWith6Decimals())").font(.subheadline)
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Spent" : "Earned")
                        Spacer()
                        Text("\(trade.money.asCurrencyWith2Decimals())").font(.subheadline)
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Bought Coins" : "Sold Coins")
                        Spacer()
                        Text("\(trade.cryptoCoinAmount.asNumberStringWithSixDecimals())").font(.subheadline)
                    }
                }
                Divider()
            }
        }
    }
}
