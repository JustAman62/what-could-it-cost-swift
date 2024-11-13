extension Game {
    static var sampleDaily: Game {
        .init(
            type: .daily,
            products: [.sample1, .sample2, .sample3, .sample4, .sample5],
            answers: []
        )
    }
}

extension Product {
    static var sample1: Product {
        .init(
            brand: "Dreamies",
            name: "Cat Treat Biscuits with Salmon Flavour Adult & Kitten (60g)",
            productId: "JHP321",
            previousActualPrice: 1.20,
            actualPrice: 1.30
        )
    }
    static var sample2: Product {
        .init(
            brand: "Pot Noodle",
            name: "Instant Snack Original Curry Flavour (90g)",
            productId: "UWN533",
            previousActualPrice: 1.09,
            actualPrice: 1.13
        )
    }
    static var sample3: Product {
        .init(
            brand: "Simple",
            name: "Kind To Skin Moisturising Facial Wash Gel (150ml)",
            productId: "VFN172",
            previousActualPrice: 2.56,
            actualPrice: 2.94
        )
    }
    static var sample4: Product {
        .init(
            brand: "Comfort",
            name: "Pure Fabric Conditioner 36 Washes (1.26l)",
            productId: "VJQ060",
            previousActualPrice: 1.99,
            actualPrice: 1.99
        )
    }
    static var sample5: Product {
        .init(
            brand: "Naked",
            name: "Noodle Singapore Curry Pot Egg Noodles (78g)",
            productId: "VOD416",
            previousActualPrice: 1.01,
            actualPrice: 1.06
        )
    }
}
