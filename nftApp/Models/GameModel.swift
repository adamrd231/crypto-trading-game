import Foundation
import SwiftUI

struct GameTrade: Identifiable, Codable {
    let id = UUID().uuidString
    let type: String
    let coinName: String
    let priceOfCrypto: Double
    let dateOfTrade: Date
    var money: Double
    let cryptoCoinAmount: Double

}

class GameModel: Identifiable, ObservableObject {
    let id = UUID().uuidString
    @Published(key: "game") var gameDollars: Double = 100000
    @Published(wrappedValue: Date(), key: "date") var startingDate: Date
}


