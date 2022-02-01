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
            
            Text("Trades").font(.title)
            ScrollView {
                
                Picker("Filter", selection: $pickerSelection) {
                    ForEach(0..<pickerStatus.count) { index in
                        Text("\(pickerStatus[index])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                if pickerStatus[pickerSelection] == "Purchases" {
                    allPurchaseTrades
                } else if pickerStatus[pickerSelection] == "Sales" {
                    allSalesTrades
                } else {
                    allTrades
                }
                
                
            }
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
                        Text("Type").bold()
                        Spacer()
                        Text("\(trade.type)").font(.footnote)
                    }
                    HStack {
                        Text("Coin").bold()
                        Spacer()
                        Text("\(trade.coinName)")
                    }
                    HStack {
                        Text("Date:").bold()
                        Spacer()
                        Text("\(trade.dateOfTrade.asLongDateString())")
                    }
                    HStack {
                        Text("Price of Crypto Coin:").bold()
                        Spacer()
                        Text(" \(trade.priceOfCrypto.asCurrencyWith6Decimals())")
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Spent" : "Earned").bold()
                        Spacer()
                        Text("\(trade.money.asCurrencyWith2Decimals())")
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Bought Coins" : "Sold Coins").bold()
                        Spacer()
                        Text("\(trade.cryptoCoinAmount.asNumberStringWithSixDecimals())")
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
                    Text("Type").bold()
                    Spacer()
                    Text("\(trade.type)").font(.footnote)
                }
                HStack {
                    Text("Coin").bold()
                    Spacer()
                    Text("\(trade.coinName)")
                }
                HStack {
                    Text("Date:").bold()
                    Spacer()
                    Text("\(trade.dateOfTrade.asShortDateString())")
                }
                HStack {
                    Text("Price of Crypto Coin:").bold()
                    Spacer()
                    Text(" \(trade.priceOfCrypto.asCurrencyWith6Decimals())")
                }
                HStack {
                    Text(trade.type == "Purchase" ? "Spent" : "Earned").bold()
                    Spacer()
                    Text("\(trade.money.asCurrencyWith2Decimals())")
                }
                HStack {
                    Text(trade.type == "Purchase" ? "Bought Coins" : "Sold Coins").bold()
                    Spacer()
                    Text("\(trade.cryptoCoinAmount.asNumberStringWithSixDecimals())")
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
                        Text("Type").bold()
                        Spacer()
                        Text("\(trade.type)").font(.footnote)
                    }
                    HStack {
                        Text("Coin").bold()
                        Spacer()
                        Text("\(trade.coinName)")
                    }
                    HStack {
                        Text("Date:").bold()
                        Spacer()
                        Text("\(trade.dateOfTrade.asShortDateString())")
                    }
                    HStack {
                        Text("Price of Crypto Coin:").bold()
                        Spacer()
                        Text(" \(trade.priceOfCrypto.asCurrencyWith6Decimals())")
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Spent" : "Earned").bold()
                        Spacer()
                        Text("\(trade.money.asCurrencyWith2Decimals())")
                    }
                    HStack {
                        Text(trade.type == "Purchase" ? "Bought Coins" : "Sold Coins").bold()
                        Spacer()
                        Text("\(trade.cryptoCoinAmount.asNumberStringWithSixDecimals())")
                    }
                }
                Divider()
            }
        }
    }
}
