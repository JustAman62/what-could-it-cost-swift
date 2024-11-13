import SwiftUI

struct ContentView: View {
    @State var gameType: GameType?
    
    var body: some View {
        ZStack {
            Color
                .brand
                .ignoresSafeArea()
            
            VStack {
                Text("What Could It Cost?")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                Button {
                    gameType = .daily
                } label: {
                    Text("Play Daily")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .padding()
        }
        .fullScreenCover(item: $gameType) { type in
            ZStack {
                Color
                    .brand
                    .ignoresSafeArea()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button {
                            gameType = nil
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.title)
                        }
                    }
                    .padding()
                    Spacer()
                }
                
                GameSheet(type: type)
            }
        }
    }
}

#Preview {
    ContentView()
}
