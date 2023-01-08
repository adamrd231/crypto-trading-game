//
//  UserTradeActivityView.swift
//  nftApp
//
//  Created by Adam Reed on 1/3/23.
//

import SwiftUI

struct UserTradeActivityView: View {
    @State var vm = HomeViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Total Trades")
                    Spacer()
                    Text(vm.allTrades.count.description)
                }
                HStack {
                    Text("Money Spent in Trades")
                    Spacer()
                    Text(vm.moneySpent.asCurrencyWith2Decimals())
                }
                HStack {
                    Text("Current Portfolio Value")
                    Spacer()
                    Text(vm.portfolioValue.asCurrencyWith2Decimals())
                }
                HStack {
                    Text("Growth / Loss")
                    Spacer()
                    Text((((vm.portfolioValue - vm.moneySpent) / vm.moneySpent) * 100).asPercentString())
                }
            }
            .onAppear {
                print("coins in portfolio: \(vm.portfolioCoins.count)")
            }
            .padding()
            
            List(vm.allTrades) { trade in
                VStack {
                    Text("\(trade.coinName)")
                    HStack {
                        Text("Coin Purchased at")
                        Spacer()
                        Text("\(trade.priceOfCrypto)")
                    }
                    .font(.caption2)
                    HStack {
                        Text("Coins Purchased")
                        Spacer()
                        Text("\(trade.cryptoCoinAmount)")
                    }
                    .font(.caption2)
                    HStack {
                        Text("Money Spent")
                        Spacer()
                        Text("\(trade.money)")
                    }
                    .font(.caption2)
                }
            }
        }
        .onAppear(perform: {
            vm.portfolioDataService.getTrades()
        })
    }
}

struct UserTradeActivityView_Previews: PreviewProvider {
    static var previews: some View {
        UserTradeActivityView()
    }
}
