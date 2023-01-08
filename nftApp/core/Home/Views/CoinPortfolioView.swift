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


struct CoinView: View {
    let coin: CoinModel
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVGrid(columns: columns, alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(coin.symbol.description)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(coin.name.description)
                }
                CoinImageView(coin: coin)
                    .frame(width: 25, height: 25, alignment: .center)
                CoinStat(title: "Owned", coinStat: coin.currentHoldings ?? 0)
                CoinStat(title: "Holdings", coinStat: coin.currentHoldingsValue )
                CoinStat(title: "24 Change", coinStat: coin.priceChange24H ?? 0)
                CoinStat(title: "Rank", coinStat: coin.marketCapRank ?? 0)
            }
            .padding()
        }
    }
}


