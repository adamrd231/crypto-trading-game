import SwiftUI

struct PortfolioStatDate: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.title)
            Spacer()
            Text(date.asShortDateString())
                .font(.title)
        }
    }
}

struct PortfolioStatDate_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioStatDate(title: "hello", date: Date())
    }
}
