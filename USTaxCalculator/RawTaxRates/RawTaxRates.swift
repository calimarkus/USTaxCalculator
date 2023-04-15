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
    let federalRates: FederalTaxRates
    let californiaRates: CaliforniaStateTaxRates
    let newYorkRates: NewYorkStateTaxRates
}

struct FederalTaxRates {
    let incomeRates: [FilingType: RawTaxRates]
    let standardDeductions: [FilingType: Double]

    let longtermGainsRates: [FilingType: RawTaxRates]

    // - "Net investment income" generally does not include wages, social security benefits, ...
    // - The tax applies to the the lesser of the net investment income, or the amount by which the
    //   modified adjusted gross income exceeds the statutory threshold amount
    let netInvestmentIncomeRates: [FilingType: RawTaxRates]

    // medicare is usually withheld by the employer
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
