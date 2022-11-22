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
    @State var usersTotalMoney: Double?
    @State var totalBalance = 100
    
    @State var startAngle: Double = 0
    @State var toAngle: Double = 0
    @State var startProgress: Double = 0
    @State var toProgress: Double = 0
    @State var amountOfCoinsToPurchase: Double = 0
    @State var moneySpentOnPurchase: Double = 0
    

    var purchasePrice: Double {
        return coin.currentPrice * quantityOfCoinPurchase
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (coin.currentHoldings ?? 0 > 0) {
                Picker("", selection: $pickerChoice) {
                    ForEach(pickerChoices, id: \.self) { choice in
                        Text(choice)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
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
                            ZStack {
                                Circle()
                                    .stroke(.black.opacity(0.016), lineWidth: 40)
                                
                                Circle()
                                    .trim(from: startProgress, to: toProgress)
                                    .stroke(Color.blue.opacity(0.66), style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round, miterLimit: .greatestFiniteMagnitude))
                                
                                Circle()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundColor(.white)
                                    .offset(x: width / 2)
                                    .rotationEffect(.init(degrees: startAngle))
                                
                                
                                Circle()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundColor(.red)
                                    .offset(x: width / 2)
                                    .rotationEffect(.init(degrees: toAngle))
                                    .gesture(
                                        DragGesture()
                                            .onChanged({ value in
                                                onDrag(value: value)
                                            })
                                    )
                            }
                            .rotationEffect(.init(degrees: -90))
                                
                            
                            VStack {
                                Text("\(amountOfCoinsToPurchase.asNumberString()) \(coin.name)")
                                Text("Coin price: \(coin.currentPrice.asCurrencyWith2Decimals())")
                                Text("Total: \(moneySpentOnPurchase.asCurrencyWith2Decimals())")
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
        .onAppear {
            toProgress = (vm.storeManager.game.gameDollars * 0.1) / vm.storeManager.game.gameDollars
            toAngle = 36
            amountOfCoinsToPurchase = (vm.storeManager.game.gameDollars * 0.1) / coin.currentPrice
            moneySpentOnPurchase = coin.currentPrice * amountOfCoinsToPurchase
        }
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        print("angle: \(angle)")
        let progress = (angle / 360)
        
        if angle < 359 {
            self.toAngle = angle
            self.toProgress = progress
            self.moneySpentOnPurchase = (vm.storeManager.game.gameDollars) * progress
            self.amountOfCoinsToPurchase = self.moneySpentOnPurchase / coin.currentPrice
        } else if angle < 2 {
            self.toAngle = 0
            self.toProgress = 0
            self.moneySpentOnPurchase = 0
            self.amountOfCoinsToPurchase = 0
        } else {
            self.toAngle = 360
            self.toProgress = 1.0
            self.moneySpentOnPurchase = vm.storeManager.game.gameDollars
            self.amountOfCoinsToPurchase = self.moneySpentOnPurchase / coin.currentPrice
        }
 
       
        
    }
}

struct BuySellView_Previews: PreviewProvider {
    static var previews: some View {
        BuySellView(coin: dev.coin)
    }
}
