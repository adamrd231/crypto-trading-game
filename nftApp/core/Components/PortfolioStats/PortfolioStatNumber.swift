import SwiftUI

struct PortfolioStatNumber: View {
    let title: String
    let value: Double
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.title)
            Spacer()
            Text(String(format: "%.2f", value))
                .font(.title)
        }
    }
}

struct PortfolioStatNumber_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioStatNumber(title: "Number", value: 15000)
    }
}
