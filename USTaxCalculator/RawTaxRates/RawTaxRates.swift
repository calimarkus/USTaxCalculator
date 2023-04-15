//
//

struct RawTaxRate {
    let startingAt: Double
    let rate: Double
}

enum RawTaxRateType {
    case simple
    case progressive
}

struct RawTaxRates {
    let sortedRates: [RawTaxRate]
    let type: RawTaxRateType

    init(simple startingAtToTaxRateMap: [Double: Double]) {
        self.init(startingAtToTaxRateMap, .simple)
    }

    init(progressive startingAtToTaxRateMap: [Double: Double]) {
        self.init(startingAtToTaxRateMap, .progressive)
    }

    private init(_ startingAtToTaxRateMap: [Double: Double], _ type: RawTaxRateType) {
        let rates = startingAtToTaxRateMap.map { startingAt, rate in
            RawTaxRate(startingAt: startingAt, rate: rate)
        }
        self.sortedRates = rates.sorted { $0.startingAt < $1.startingAt }
        self.type = type
    }
}
