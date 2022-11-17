//
//  BuySellView.swift
//  nftApp
//
//  Created by Adam Reed on 11/16/22.
//

import SwiftUI

struct BuySellView: View {
    @State var storeManager = StoreManager()
    @State var pickerChoices = ["BUY" , "SELL"]
    @State var pickerChoice = "BUY"
    @State var coin: CoinModel
    @State var quantityOfCoinPurchase: Double = 0
    @State var vm = HomeViewModel()
    var purchasePrice: Double {
        return coin.currentPrice * quantityOfCoinPurchase
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Game Monies")
            Text(storeManager.game.gameDollars.asCurrencyWith2Decimals())
            
            Picker("", selection: $pickerChoice) {
                ForEach(pickerChoices, id: \.self) { choice in
                    Text(choice)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
           
            if (pickerChoice == "BUY") {
                VStack {
                    HStack {
                        Text("Buy")
                        Spacer()
                        Text("Cost")
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 3)
                                .foregroundColor(Color.theme.secondaryText)
                                
                            TextField("\(quantityOfCoinPurchase)", value: $quantityOfCoinPurchase, format: .number)
                                .padding(5)
                        }
               
                        Spacer()
                        Text(purchasePrice.asCurrencyWith2Decimals())
                            .padding(5)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                    
                    Button("Purchase") {
                        vm.updateForPurchase(coin: coin, amountSpentPurchasingCrypto: quantityOfCoinPurchase)
                        print("new trade")
                        
                    }
                    .padding()
                    .disabled(purchasePrice > storeManager.game.gameDollars)
                    
                    .foregroundColor(purchasePrice > storeManager.game.gameDollars ? Color.theme.red  : Color.theme.accent)
                    .frame(width: .infinity)
                }
            } else {
                if coin.currentHoldings == 0 {
                    Text("No Coins Owned")
                } else {
                    HStack {
                        Text("Coins Owned")
                        Spacer()
                        Text(coin.currentHoldings?.asNumberString() ?? "")
                    }
                }
            } 
        }
    }
}

struct BuySellView_Previews: PreviewProvider {
    static var previews: some View {
        BuySellView(coin: dev.coin)
    }
}
