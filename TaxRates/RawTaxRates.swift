//
// RawTaxRates.swift
//

import Foundation

public struct RawTaxRate {
    public let startingAt: Double
    public let rate: Double
}

public enum RawTaxRateType {
    case simple
    case progressive
    case interpolated
}

public struct RawTaxRates {
    public let type: RawTaxRateType
    public let sortedRates: [RawTaxRate]
    public let sources: [URL]

    init(_ type: RawTaxRateType, _ startingAtToTaxRateMap: [Double: Double], sources: [URL] = []) {
        let rates = startingAtToTaxRateMap.map { startingAt, rate in
            RawTaxRate(startingAt: startingAt, rate: rate)
        }
        sortedRates = rates.sorted { $0.startingAt < $1.startingAt }
        self.type = type
        self.sources = sources
    }
}

public struct RawStandardDeduction {
    public let value: Double
    public let sources: [URL]

    init(_ value: Double, sources: [URL] = []) {
        self.value = value
        self.sources = sources
    }
}

public struct RawFederalTaxRates {
    public let incomeRates: RawTaxRates
    public let standardDeductions: RawStandardDeduction

    public let longtermGainsRates: RawTaxRates

    // - "Net investment income" generally does not include wages, social security benefits, ...
    // - The tax applies to the the lesser of the net investment income, or the amount by which the
    //   modified adjusted gross income exceeds the statutory threshold amount
    public let netInvestmentIncomeRates: RawTaxRates

    // medicare is usually withheld by the employer
    public let basicMedicareIncomeRates: RawTaxRates
    public let additionalMedicareIncomeRates: RawTaxRates
}

public protocol RawStateTaxRates {
    var standardDeductions: RawStandardDeduction { get }
    func incomeRates(forIncome income: Double) -> RawTaxRates
}

public struct RawCaliforniaStateTaxRates: RawStateTaxRates {
    public let incomeRates: RawTaxRates
    public let standardDeductions: RawStandardDeduction

    public var lowIncomeRatesLimit: Double
    public let lowIncomeRates: RawTaxRates

    public let mentalHealthRates: RawTaxRates

    public func incomeRates(forIncome income: Double) -> RawTaxRates {
        // CA doesn't use progressive rates for incomes lower or equal to X
        income <= lowIncomeRatesLimit ? lowIncomeRates : incomeRates
    }
}

public struct RawNewYorkStateTaxRates: RawStateTaxRates {
    public let incomeRates: RawTaxRates
    public let standardDeductions: RawStandardDeduction

    public var highIncomeRateThreshhold: Double
    public let highIncomeRates: RawTaxRates

    public let newYorkCityRates: RawTaxRates

    public func incomeRates(forIncome income: Double) -> RawTaxRates {
        // new york doesn't use progressive rates for incomes higher than X
        income > highIncomeRateThreshhold ? highIncomeRates : incomeRates
    }
}
