import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let userOwnsCoin: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            centerColumn
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, userOwnsCoin: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, userOwnsCoin: false)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}


extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            // Replace this with actual images downloaded from internet
            CoinImageView(coin: coin).frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .fixedSize(horizontal: true, vertical: true)

            if (userOwnsCoin) {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .center)
                    .foregroundColor(Color.theme.green)
            }
        }
    }
    
    private var centerColumn: some View {

        VStack(alignment: .center) {
            HStack {
                Text(coin.ath?.asCurrencyWith2Decimals() ?? "N/A")
                    .font(.caption)
                    .bold()
                Text(coin.atl?.asCurrencyWith2Decimals() ?? "N/A")
                    .font(.caption)
                    .bold()
            }
            .lineLimit(1)
        }
        .foregroundColor(Color.theme.accent)

    }
    
    private var rightColumn: some View {
        VStack {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .font(.caption)
                .bold()
                .foregroundColor(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .foregroundColor(
                        coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red)

        }
        .frame(width: UIScreen.main.bounds.width / 3.5)
    }
    
    
}
