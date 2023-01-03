//
//  CoinPortfolioView.swift
//  nftApp
//
//  Created by Adam Reed on 11/15/22.
//

import SwiftUI

struct CoinStat: View {
    
    let title: String
    let coinStat: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            Text(coinStat.asNumberString())
        }
    }
}

struct CoinStatCurrency: View {
    
    let title: String
    let coinStat: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            Text(coinStat.asCurrencyWith2Decimals())
        }
    }
}

struct ValueChangeStat: View {
    let title: String
    let coinStat: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .fontWeight(.bold)
            HStack {
                Image(systemName: (coinStat > 0) ?  "arrow.up.circle" : "arrow.down.circle")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .leading)
                    .foregroundColor(coinStat > 0 ? .green : .red)
                Text(coinStat.description)
            }
        }
    }
}

struct CoinView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(coin.symbol.description)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(coin.name.description)
                }
                Spacer()
                ZStack {
                    Rectangle()
                        .background(Color.theme.accent)
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(5)
                    CoinImageView(coin: coin)
                        .frame(width: 25, height: 25, alignment: .center)
                }
            }
            
            CoinStat(title: "Owned", coinStat: coin.currentHoldings ?? 0)
            CoinStat(title: "Holdings", coinStat: coin.currentHoldingsValue )
            CoinStat(title: "24 Change", coinStat: coin.priceChange24H ?? 0)
            CoinStat(title: "Market Rank", coinStat: coin.marketCapRank ?? 0)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct CoinPortfolioView: View {
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        
        ForEach(vm.portfolioCoins) { coin in
            NavigationLink(destination: DetailView(coin: coin, userOwnsCoin: vm.portfolioCoins.contains(coin))) {
                CoinView(coin: coin)
            }
        }
    }
}

struct CoinPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        CoinPortfolioView(vm: dev.homeVM)
    }
}


