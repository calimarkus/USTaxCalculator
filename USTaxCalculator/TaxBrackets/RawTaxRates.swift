//
//

struct RawTaxRate {
    let startingAt: Double
    let rate: Double
}

struct RawTaxRates {
    let sortedRates: [RawTaxRate]

    init(_ startingAtToTaxRateMap: [Double: Double]) {
        let rates = startingAtToTaxRateMap.map { startingAt, rate in
            RawTaxRate(startingAt: startingAt, rate: rate)
        }
        self.sortedRates = rates.sorted { $0.startingAt < $1.startingAt }
    }
}

// state rates
enum RawStateTaxRates {
    static func progressiveMapsForState(_ state: TaxState) -> [TaxYear: [FilingType: RawTaxRates]] {
        switch state {
        case .NY: return RawStateTaxRates.progressiveNewYorkStateRates
        case .CA: return RawStateTaxRates.californiaRates
        }
    }
}

// city rates
enum RawCityTaxRates {
    static func progressiveMapsForCity(_ city: TaxCity) -> [TaxYear: [FilingType: RawTaxRates]] {
        switch city {
        case .NYC: return RawCityTaxRates.newYorkCityRates
        }
    }
}
