//
//  PortfolioView.swift
//  nftApp
//
//  Created by Adam Reed on 1/18/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State private var selectedCoin: CoinModel?
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    let comma: Set<Character> = [","]
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showPortfolio: Bool // animate bin
    
    // MARK: Trade variables
    @State var buyAmount: String = ""
    @State var sellAmount: String = ""
    
    @State var selectedIndexForPicker: Int = 0
    var pickerValues:[String] = ["BUY", "SELL"]
    @State var showingPaymentAlert: Bool = false
    
    @State var currentAlert: AlertCases = .purchaseSuccessful
    
    enum AlertCases {
        case purchaseSuccessful
        case purchaseNotSuccessful
        case saleSuccessful
        case saleNotSuccessful
    }
    
    // Custom Alerts
    func createAlert() -> Alert {
        
        switch currentAlert {
        case .purchaseSuccessful: return Alert(title: Text("Nice Investment"), message: Text("You Bought Some Crypto Coins! That's A Metaphorical Three Pointer."), dismissButton: .default(Text("Done")))
        case .purchaseNotSuccessful: return Alert(title: Text("Hold Up"), message: Text("You Do Not Have Enough 'Money' To Buy This Much Crypto Coin."), dismissButton: .default(Text("Done")))
        case .saleSuccessful: return Alert(title: Text("CA-CHING!"), message: Text("Sold Crypto Coins, Way To Sell Out!"), dismissButton: .default(Text("Done")))
        case .saleNotSuccessful: return Alert(title: Text("Whoa There"), message: Text("Not enough Crypto Coins To Make This Sale, Maybe Sell Less, Or Not, I'm Not The Boss."), dismissButton: .default(Text("Done")))
        }
    }
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if let coin = selectedCoin {
                        Picker("buy / sell", selection: $selectedIndexForPicker) {
                            ForEach(0..<pickerValues.count) { index in
                                Text("\(pickerValues[index])")
                            }
                        }
                        .padding(.horizontal)
                        .pickerStyle(SegmentedPickerStyle())
        
                        portfolioInputSection
                        .animation(.default)
                        .padding()
                        .font(.headline)
                    }
                }
                Spacer()
            }
            .navigationTitle("Buy / Sell Coins")
            .alert(isPresented: $showingPaymentAlert, content: {
                // decide which alert to show
               createAlert()
                
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
        .navigationBarHidden(true)
    }
}


// MARK: Preview Provider
// ---------------------------
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(showPortfolio: .constant(true)).environmentObject(dev.homeVM)
    }
}



// MARK: Extensions
// ---------------------------
extension PortfolioView {
    
    // MARK: Functions
    // Function to update the selected coin with new information
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
            let amount = portfolioCoin.currentHoldings {
                quantityText = "\(amount)"
            } else {
                quantityText = "0"
            }
        }
    
    // Function to get the current value of the coins owned by a user for a single coin
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        
        
        // Seperate out puchase or sale before calling function, verify that needed information
        if pickerValues[selectedIndexForPicker] == "BUY" {
            if let coin = selectedCoin,
               let purchaseAmount = Double(buyAmount.replacingOccurrences(of: ",", with: "")) {
                // Update Game
                let numberOfCoins = (1 / coin.currentPrice) * purchaseAmount
                
                if vm.storeManager.game.gameDollars < purchaseAmount {
                    print("Not Enough Money")
                    // Show Alert that user does not have enough money
                    currentAlert = .purchaseNotSuccessful
                    showingPaymentAlert.toggle()
                    return
                } else {
                    
                    vm.storeManager.game.gameDollars -= purchaseAmount
                    
                    vm.updateForPurchase(coin: coin, amountSpentPurchasingCrypto: purchaseAmount)
                    vm.updatePortfolio(coin: coin, amount: numberOfCoins)
                    
                    // Show Alert for successful coin purchase
                    currentAlert = .purchaseSuccessful
                    buyAmount = ""
                    sellAmount = ""
                    
                    showingPaymentAlert.toggle()
                }
                
                // Update portfolio
                
                
            }
        } else if pickerValues[selectedIndexForPicker] == "SELL" {
            if let coin = selectedCoin,
               let saleAmount = Double(sellAmount.replacingOccurrences(of: ",", with: "")) {
                
                let moneyFromSale = (coin.currentPrice * saleAmount)
                
                if coin.currentHoldings ?? 0 < saleAmount {
                    // Show Alert that user does not have enough crypto
                    currentAlert = .saleNotSuccessful
                    showingPaymentAlert.toggle()
                    return
                }
                
                vm.storeManager.game.gameDollars += moneyFromSale
                
                vm.updateForSale(coin: coin, amountOfCryptoSold: saleAmount)
                let negativeNumber = saleAmount * -1
                print("Negative Number: \(negativeNumber)")
                vm.updatePortfolio(coin: coin, amount: negativeNumber)
                
                // Show Alert that user sold crypto
                currentAlert = .saleSuccessful
                buyAmount = ""
                sellAmount = ""
                showingPaymentAlert.toggle()
            }
        }
        
           
        // Save to portfolio
        
        
        // Show Checkmark
        withAnimation(.easeIn) {
            removeSelectedCoin()
        }
        
        // Hide the keyboard
        UIApplication.shared.endEditing()
        
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
    
    // MARK: Views
    // Horizontal CoinLogo List to display coins the user wants to purchase
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(selectedCoin?.id == coin.id ? Color.theme.background : Color.clear)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
        
    }
 
    func calculateAmountReceived(coin: CoinModel) -> Text {
        let conversionRate = 1 / coin.currentPrice
        
        let noCommas = buyAmount.replacingOccurrences(of: ",", with: "")
        
        print("no commas: \(noCommas)")
        print("Double: \(Double(noCommas))")
        if let purchaseAmount = Double(noCommas) {
            print("Inside let")
            let amountRecieved = conversionRate * purchaseAmount
            print("amount Recieved: \(amountRecieved)")
            return Text("\(amountRecieved)")
        } else {
            return Text("")
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            
            if selectedIndexForPicker == 0 {
                HStack {
                    HStack {
                        Text("Current price of: ")
                        Spacer()
                        if let coin = selectedCoin {
                            CoinImageView(coin: coin)
                                .frame(width: 15, height: 15, alignment: .center)
                        }
                        Text(selectedCoin?.symbol.uppercased() ?? "").font(.caption)
                            
                    }
                    Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "").font(.caption)
                }
                
                Divider()
                HStack {
                    Text("Game Money:")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text((vm.storeManager.game.gameDollars ?? 0).asCurrencyWith2Decimals()).font(.caption)
                        
                    }
                    
                }
                
                HStack {
                    Text("Spend")
                    Spacer()
                    Text("$")
//                    TextField("Ex: $1,000", value: $buyAmount, formatter: formatter)
                    TextField("Ex: $1,000", text: $buyAmount)
                        .onChange(of: buyAmount, perform: { value in
                        
                            let cleanNumber = buyAmount.replacingOccurrences(of: ",", with: "")
                            if let number = Double(cleanNumber) {
                                let value = formatter.string(from: NSNumber(value: number))
                                buyAmount = value ?? ""
                            }
                            
                        })
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .foregroundColor(Double(buyAmount.replacingOccurrences(of: ",", with: "")) ?? 0 > vm.storeManager.game.gameDollars ?? 0 ? Color.theme.red : Color.theme.green).font(.caption)
                        
                }
                
                HStack {
                    Text("Amount recieved:")
                    Spacer()
                    if let coin = selectedCoin {
                        calculateAmountReceived(coin: coin)
                            .font(.caption)
                            .foregroundColor((Double(buyAmount.replacingOccurrences(of: ",", with: "")) ?? 0 > vm.storeManager.game.gameDollars ?? 0) ? Color.theme.secondaryText : .primary)
                    } else {
                        Text("No COin")
                    }

                        
      
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        
                        saveButtonPressed()
                       
                    }) {
                        Text("Buy")
                            .padding()
                            .background(Color.theme.background)
                    }
                }
                
                
            } else {
                HStack {
                    HStack {
                        Text("Current price of: ")
                        Spacer()
                        if let coin = selectedCoin {
                            CoinImageView(coin: coin)
                                .frame(width: 15, height: 15, alignment: .center)
                        }
                        Text(selectedCoin?.symbol.uppercased() ?? "").font(.caption)
                    }
                    Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "").font(.caption)
                }
                
                HStack {
                    Text("Value of coins you hold:")
                    Spacer()
                    if let coin = selectedCoin {
                        Text(coin.currentHoldingsValue.asCurrencyWith2Decimals()).font(.caption)
                    }
                }
                HStack {
                    Text("Number of coins you hold:")
                    Spacer()
                    if let coin = selectedCoin {
                        Text((coin.currentHoldings ?? 0).formattedwithAbbreviations()).font(.caption)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Sell how much crypto?")
                    Spacer()
                    TextField("Ex: 100 Coins", text: $sellAmount)
                        .onChange(of: sellAmount, perform: { value in
                        
                            let cleanNumber = sellAmount.replacingOccurrences(of: ",", with: "")
                            if let number = Double(cleanNumber) {
                                let value = formatter.string(from: NSNumber(value: number))
                                sellAmount = value ?? ""
                            }
                        })
                        
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .foregroundColor((Double(sellAmount.replacingOccurrences(of: ",", with: "")) ?? 0 > selectedCoin?.currentHoldings ?? 0) ? Color.theme.red : Color.theme.green)
          
                }
                
                HStack {
                    Text("Value recieved:")
                    Spacer()
                    if
                        let price = selectedCoin?.currentPrice,
                        let sell = Double(sellAmount.replacingOccurrences(of: ",", with: "")) {
                        Text((sell * price).asCurrencyWith2Decimals())
                            .font(.caption)
                            .foregroundColor((Double(sellAmount.replacingOccurrences(of: ",", with: "")) ?? 0 > selectedCoin?.currentHoldings ?? 0) ? Color.theme.secondaryText : .primary)
                    }
                }
                
                HStack {
                    Button(action: {
                        // Selling crypto coins
                        saveButtonPressed()
                      
                        // create and save trade
                        // add value of coins to game dollars
                        // Update portfolioCoins with new coin information
                    }) {
                        Spacer()
                        Text("Sell")
                            .padding()
                            .background(Color.theme.background)
                    }
                }
            }
        }
    }
}
