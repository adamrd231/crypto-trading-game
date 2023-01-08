import SwiftUI

struct PortfolioStatePercentage: View {
    let title: String
    let value: Double
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.title)
            Spacer()
            Text(value.asPercentString())
                .foregroundColor(value > 0 ? .green : .red)
                .font(.title)
        }
    }
}

struct PortfolioStatePercentage_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioStatePercentage(title: "hello", value: 1.43)
    }
}
