import Foundation

struct UserPortfolio: Identifiable {
    let id = UUID().uuidString
    let name: String
    var coins: [CoinModel]

    
    init(name: String, coins: [CoinModel], percentageChanged: Double? = nil) {
        self.name = name
        self.coins = coins
        
    }
}


