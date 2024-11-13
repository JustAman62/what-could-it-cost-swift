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
                reviewAnswer(round: round, product: product, price: price)
            case .finished:
                finished()
            }
        }
    }
    
    struct RoundHeader: View {
        let round: Int
        let product: Product
        
        @State var answer: String = ""
        
        var body: some View {
            VStack {
                Text("Round \(round + 1)/5")
                    .font(.headline)

                AsyncImage(url: URL(string: "https://trolley.co.uk/img/product/\(product.productId)")!) { image in
                    if let image = image.image {
                        image.resizable()
                    }
                }
                .padding()
                .frame(maxWidth: 300, maxHeight: 300)
                .background(.white)
                .clipShape(.rect(cornerRadius: 16))
            }
        }
    }
    
    struct WaitingForAnswer: View {
        let round: Int
        let product: Product
        
        @State private var answer: Decimal = 0
        
        private var formatter: Formatter {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits = 2
            f.zeroSymbol = ""
            return f
        }
        
        var body: some View {
            VStack {
                Text("How Much Does This Cost?")
                    .font(.subheadline)
                    .padding(.top)
                
                HStack {
                    Text("£")
                    TextField("Your Guess", value: $answer, formatter: formatter)
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                }
                .padding()
                .frame(width: 300)
                .background(.white)
                .clipShape(.rect(cornerRadius: 16))

                Spacer()
            }
        }
    }

    @ViewBuilder func reviewAnswer(round: Int, product: Product, price: Decimal) -> some View {
        
        Text("Review")
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
}
#endif
