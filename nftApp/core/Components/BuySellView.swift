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
    
    // Circle vars
    @State var startAngle: Double = 0
    @State var toAngle: Double = 0
    @State var startProgress: Double = 0
    @State var toProgress: Double = 0.5
    
    var purchasePrice: Double {
        return coin.currentPrice * quantityOfCoinPurchase
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Game Monies")
            Picker("", selection: $pickerChoice) {
                ForEach(pickerChoices, id: \.self) { choice in
                    Text(choice)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
           
            if (pickerChoice == "BUY") {
                GeometryReader { geo in
                    VStack(alignment: .center) {
                        let width = geo.size.width
                        
                        
                        ZStack {
                            ZStack {
                                ForEach(1...60, id: \.self) { index in
                                    Rectangle()
                                        .fill(index % 5 == 0 ? .black : .gray)
                                        .frame(width: 2, height: index % 5 == 0 ? 15 : 5)
                                        .offset(y: (width) / 2)
                                        .rotationEffect(.init(degrees: Double(index) * 6))
                                }
                            }
                            
                            Circle()
                                .stroke(.black.opacity(0.066), lineWidth: 40)
                            
                            Circle()
                                .trim(from: startProgress, to: toProgress)
                                .stroke(Color.blue.opacity(0.66), style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round, miterLimit: .greatestFiniteMagnitude))
                                .rotationEffect(.init(degrees: -90))
                            
                            Image(systemName: "pencil.circle.fill")
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.gray)
                                .background(.white, in: Circle())
                                .offset(x: width / 2)
                                .rotationEffect(.init(degrees: -90))
                                .rotationEffect(.init(degrees: startAngle))
                 
                            
                            Image(systemName: "pencil.circle.fill")
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.blue)
                                .background(.white, in: Circle())
                        
                                .offset(x: width / 2)
                                .rotationEffect(.init(degrees: 90))
                                .rotationEffect(.init(degrees: toAngle))
                            
                            VStack {
                                Text("Buy (Number of Coins)")
                                Text("Cost ($100.00)")
                            }
                        }
                        
                        Button((pickerChoice == "BUY") ? "Purchase" : "Sell") {
                            print("new trade")
                            vm.updateForPurchase(coin: coin, amountSpentPurchasingCrypto: purchasePrice)
                            vm.portfolioCoins.append(coin)
                        }
                        .padding()
                        .disabled(purchasePrice > storeManager.game.gameDollars)
                        .foregroundColor(purchasePrice > storeManager.game.gameDollars ? Color.theme.red  : Color.theme.accent)
                    }
                }
                .frame(height: 400)
                .padding()
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
