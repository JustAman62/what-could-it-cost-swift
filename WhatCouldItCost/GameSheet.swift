import SwiftUI

struct GameSheet : View {
    var type: GameType
    
    @State private var game: Game?

    var body: some View {
        if let game = game {
            GameView(game: game)
        } else {
            ProgressView("Loading...")
        }
    }
}
