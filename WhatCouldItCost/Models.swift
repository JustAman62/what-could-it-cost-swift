import SwiftUI

@Observable
final class Game {
    var type: GameType
    var state: GameState
    var products: [Product]
    var answers: [Decimal]

    var lock: NSLock = .init()
    
    init(type: GameType, products: [Product], answers: [Decimal]) {
        self.type = type
        self.state = .waitingForAnswer(round: 0, product: products.first!)
        self.products = products
        self.answers = answers
    }
}

struct Product: Codable {
    var brand: String
    var name: String
    var productId: String
    var previousActualPrice: Decimal
    var actualPrice: Decimal
}

enum GameState {
    case waitingForAnswer(round: Int, product: Product)
    case reviewAnswer(round: Int, product: Product, price: Decimal)
    case finished
}

enum GameType: Identifiable {
    case daily
    case seeded(seed: Int)
    
    var seed: Int {
        switch self {
        case .seeded(seed: let seed):
            return seed
        case .daily:
            // Daily seeds is 1000 + <number of days since 1st Oct 2024>
            let rootDate = Date.init(timeIntervalSince1970: 1728601200)
            let days = Calendar.current.dateComponents([.day], from: rootDate, to: Date()).day ?? 0
            return 1000 + days
        }
    }
    
    var id: Int { seed }
}
