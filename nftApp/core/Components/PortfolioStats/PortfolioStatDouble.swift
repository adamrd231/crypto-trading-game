import SwiftUI

struct PortfolioStatDouble: View {
    let title: String
    let stat: Double
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.title)
            Spacer()
            Text(stat.asCurrencyWith2Decimals())
                .font(.title)
        }
    }
}

struct PortfolioStateDouble_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioStatDouble(title: "Number", stat: 15000)
    }
}
