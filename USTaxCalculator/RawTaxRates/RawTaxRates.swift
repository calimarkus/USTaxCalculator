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

struct RawTaxRatesYear {
    let year: TaxYear

    let federalRates: FederalTaxRates
    let californiaRates: CaliforniaStateTaxRates
    let newYorkRates: NewYorkStateTaxRates
}

struct FederalTaxRates {
    let incomeRates: [FilingType: RawTaxRates]
    let standardDeductions: [FilingType: Double]

    let longtermGainsRates: [FilingType: RawTaxRates]
    let netInvestmentIncomeRates: [FilingType: RawTaxRates]
    let basicMedicareIncomeRates: [FilingType: RawTaxRates]
    let additionalMedicareIncomeRates: [FilingType: RawTaxRates]
}

struct CaliforniaStateTaxRates {
    let incomeRates: [FilingType: RawTaxRates]
    let standardDeductions: [FilingType: Double]
}

struct NewYorkStateTaxRates {
    let incomeRates: [FilingType: RawTaxRates]
    let standardDeductions: [FilingType: Double]

    let nonProgressiveIncomeRates: [FilingType: RawTaxRates]
    let newYorkCityRates: [FilingType: RawTaxRates]
}
