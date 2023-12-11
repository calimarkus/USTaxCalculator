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
    case interpolated
}

struct RawTaxRates {
    let type: RawTaxRateType
    let sortedRates: [RawTaxRate]
    let sources: [URL]

    init(_ type: RawTaxRateType, _ startingAtToTaxRateMap: [Double: Double], sources: [URL] = []) {
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

protocol RawTaxRatesYear {
    var singleRates: RawTaxRatesGroup { get }
    var marriedJointlyRates: RawTaxRatesGroup { get }
}

struct RawTaxRatesGroup {
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

    var lowIncomeRatesLimit: Double
    let lowIncomeRates: RawTaxRates

    let mentalHealthRates: RawTaxRates

    func incomeRates(forIncome income: Double) -> RawTaxRates {
        // CA doesn't use progressive rates for incomes lower or equal to X
        if income <= lowIncomeRatesLimit {
            return lowIncomeRates
        } else {
            return incomeRates
        }
    }
}

struct NewYorkStateTaxRates {
    let incomeRates: RawTaxRates
    let standardDeductions: RawStandardDeduction

    var isEligableForHighIncomeRates: (_ taxableIncome: Double) -> Bool
    let highIncomeRates: RawTaxRates

    let newYorkCityRates: RawTaxRates
}
