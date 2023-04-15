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

// state rates
enum RawStateTaxRates {
    static func forState(_ state: TaxState) -> [TaxYear: [FilingType: RawTaxRates]] {
        switch state {
        case .NY: return RawStateTaxRates.progressiveNewYorkStateRates
        case .CA: return RawStateTaxRates.californiaRates
        }
    }
}

// city rates
enum RawCityTaxRates {
    static func forCity(_ city: TaxCity) -> [TaxYear: [FilingType: RawTaxRates]] {
        switch city {
        case .NYC: return RawCityTaxRates.newYorkCityRates
        }
    }
}
