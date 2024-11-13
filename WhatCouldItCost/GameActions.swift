import Foundation
import SwiftUI

protocol GameActions {
    func submitAnswer(_ answer: Decimal) throws
    func advanceRound() throws
}

enum GameActionError : Error, LocalizedError {
    case priceBelowMin
    
    var errorDescription: String? {
        switch self {
        case .priceBelowMin:
            return "Your guess must be above £0.00"
        }
    }
}

extension Game : GameActions {
    func submitAnswer(_ answer: Decimal) throws {
        try self.lock.withLock {
            guard answer > 0 else { throw GameActionError.priceBelowMin }
            guard case .waitingForAnswer(let round, let product) = self.state else { return }
            
            answers.append(answer)
            
            self.state = .reviewAnswer(round: round, product: product, price: answer)
        }
    }
    
    func advanceRound() throws {
        self.lock.withLock {
            guard case .reviewAnswer(let round, _, _) = self.state else { return }
            
            if round < 5 {
                self.state = .waitingForAnswer(round: round + 1, product: self.products[round + 1])
            } else {
                self.state = .finished
            }
        }
    }
}

struct GameActionEnvironmentKey: EnvironmentKey {
    static let defaultValue: GameActions = Game(
        type: .daily,
        products: [.init(brand: "", name: "", productId: "", previousActualPrice: 0, actualPrice: 0)],
        answers: []
    )
}

extension EnvironmentValues {
    var gameActions: GameActions {
        get { self[GameActionEnvironmentKey.self] }
        set { self[GameActionEnvironmentKey.self] = newValue }
    }
}
