//
// RawTaxRates.swift
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    // By using 'StaticString' we disable string interpolation, for safety
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}

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
    let sources: [URL]

    init(simple startingAtToTaxRateMap: [Double: Double], sources: [URL] = []) {
        self.init(startingAtToTaxRateMap, .simple, sources: sources)
    }

    init(progressive startingAtToTaxRateMap: [Double: Double], sources: [URL] = []) {
        self.init(startingAtToTaxRateMap, .progressive, sources: sources)
    }

    private init(_ startingAtToTaxRateMap: [Double: Double], _ type: RawTaxRateType, sources: [URL] = []) {
        let rates = startingAtToTaxRateMap.map { startingAt, rate in
            RawTaxRate(startingAt: startingAt, rate: rate)
        }
        sortedRates = rates.sorted { $0.startingAt < $1.startingAt }
        self.type = type
        self.sources = sources
    }
}

struct RawStandardDeduction {
    let value: Double
    let sources: [URL]

    init(_ value: Double, sources: [URL] = []) {
        self.value = value
        self.sources = sources
    }
}

struct RawTaxRatesYear {
    let federalRates: FederalTaxRates
    let californiaRates: CaliforniaStateTaxRates
    let newYorkRates: NewYorkStateTaxRates
}

struct FederalTaxRates {
    let incomeRates: RawTaxRates
    let standardDeductions: RawStandardDeduction

    let longtermGainsRates: RawTaxRates

    // - "Net investment income" generally does not include wages, social security benefits, ...
    // - The tax applies to the the lesser of the net investment income, or the amount by which the
    //   modified adjusted gross income exceeds the statutory threshold amount
    let netInvestmentIncomeRates: RawTaxRates

    // medicare is usually withheld by the employer
    let basicMedicareIncomeRates: RawTaxRates
    let additionalMedicareIncomeRates: RawTaxRates
}

struct CaliforniaStateTaxRates {
    let incomeRates: RawTaxRates
    let standardDeductions: RawStandardDeduction
}

struct NewYorkStateTaxRates {
    let incomeRates: RawTaxRates
    let standardDeductions: RawStandardDeduction

    let highIncomeRates: RawTaxRates
    let newYorkCityRates: RawTaxRates
}
