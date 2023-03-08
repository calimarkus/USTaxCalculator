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
extension RawTaxRates {
    static func progressiveMapsForState(_ state: TaxState) -> [TaxYear: [FilingType: RawTaxRates]] {
        switch state {
            case .NY: return self.progressiveNewYorkStateRates
            case .CA: return self.californiaRates
        }
    }

    static func progressiveMapsForCity(_ city: TaxCity) -> [TaxYear: [FilingType: RawTaxRates]] {
        switch city {
            case .NYC: return self.newYorkCityRates
        }
    }
}
