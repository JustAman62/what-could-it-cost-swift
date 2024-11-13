import SwiftUI

struct GameView : View {
    var game: Game
    
    var body: some View {
        VStack {
            switch game.state {
            case .waitingForAnswer(round: let round, product: let product):
                RoundHeader(round: round, product: product)
                WaitingForAnswer(round: round, product: product)
            case .reviewAnswer(round: let round, product: let product, price: let price):
                RoundHeader(round: round, product: product)
                ReviewAnswer(round: round, product: product, price: price)
            case .finished:
                finished()
            }
        }
        .frame(maxWidth: 500)
        .environment(\.gameActions, game)
        .padding()
        .padding(.horizontal)
    }
    
    struct RoundHeader: View {
        let round: Int
        let product: Product
        
        @State var answer: String = ""
        
        var body: some View {
            VStack {
                Text("Round \(round + 1)/5")
                    .font(.headline)

                VStack {
                    AsyncImage(url: URL(string: "https://trolley.co.uk/img/product/\(product.productId)")!) { image in
                        if let image = image.image {
                            image.resizable()
                        } else {
                            Color.white
                        }
                    }
                    .padding()
                    .aspectRatio(1, contentMode: .fit)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(maxWidth: 500)
                }
                .scaledToFill()

                Text(product.brand)
                    .font(.title2.bold())

                Text(product.name)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    struct WaitingForAnswer: View {
        let round: Int
        let product: Product
        
        @State private var answer: Decimal = 0
        
        @Environment(\.gameActions) private var actions
        @Environment(\.notifier) private var notifier
        
        private func submitAnswer() {
            notifier.execute {
                try actions.submitAnswer(answer)
            }
        }
        
        var body: some View {
            VStack {
                Text("How Much Does This Cost?")
                    .font(.subheadline.bold())
                    .padding(.top)
                
                HStack {
                    Text("£")
                    TextField("Your Guess", value: $answer, format: .currency(code: "£"))
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(.white)
                .clipShape(.rect(cornerRadius: 16))
                
                Button(action: submitAnswer) {
                    Label("Submit", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 16))
                }
                .padding(.top)
                .padding(.top)

                Spacer()
            }
        }
    }
    
    struct ReviewAnswer: View {
        let round: Int
        let product: Product
        let price: Decimal
        
        @Environment(\.gameActions) private var actions
        @Environment(\.notifier) private var notifier
        
        private func advanceRound() {
            notifier.execute {
                try actions.advanceRound()
            }
        }
        
        var body: some View {
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Text("Your Guess")
                            .font(.headline)
                        
                        Text(price.formatted(.currency(code: "GBP")))
                            .font(.title.bold())
                    }
                    
                    Spacer()

                    VStack {
                        Text("Actual Price")
                            .font(.headline)
                        
                        Text(product.actualPrice.formatted(.currency(code: "GBP")))
                            .font(.title.bold())
                    }
                }
                .padding()
                
                Button(action: advanceRound) {
                    Label("Next", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 16))
                }
                .padding(.top)

                Spacer()
            }
        }
    }
    
    @ViewBuilder func finished() -> some View {
        Text("Finished")
        
    }
}

#if DEBUG
#Preview {
    @Previewable @State var game: Game = .sampleDaily
    
    ZStack {
        Color
            .brand
            .ignoresSafeArea()
        GameView(game: game)
    }
    .previewEnvironment()
}
#endif
