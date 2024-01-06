//
// CalculatedTaxData.swift
//

import TaxPrimitives
import TaxIncomeModels
import TaxModels
import Foundation

public struct FederalTaxData {
    public let taxes: [BasicTax]

    public let totalTaxableIncome: Double
    public let totalTaxes: Double

    public let deduction: Deduction
    public let withholdings: Double
    public let credits: Double

    public let summary: TaxSummary

    public init(taxes: [BasicTax], totalTaxableIncome: Double, totalTaxes: Double, deduction: Deduction, withholdings: Double, credits: Double, summary: TaxSummary) {
        self.taxes = taxes
        self.totalTaxableIncome = totalTaxableIncome
        self.totalTaxes = totalTaxes
        self.deduction = deduction
        self.withholdings = withholdings
        self.credits = credits
        self.summary = summary
    }
}

public struct StateTaxData {
    public let state: TaxState /// The underlying state
    public let attributableIncome: AttributableIncome /// The income attributed to this state (only relevant in multi state situations)
    public let taxes: [AttributableTax]
    public var localTax: BasicTax? /// An additional optional local tax applying to this state

    public let taxableStateIncome: NamedValue
    public let additionalStateIncome: Double /// State Income that's not part of the wages on the W-2
    public let deduction: Deduction /// Deductions that apply to this state
    public let withholdings: Double /// Withholdings that apply to this state
    public let credits: Double /// Credits that apply to this state

    public let summary: TaxSummary

    public init(state: TaxState, attributableIncome: AttributableIncome, taxes: [AttributableTax], localTax: BasicTax? = nil, taxableStateIncome: NamedValue, additionalStateIncome: Double, deduction: Deduction, withholdings: Double, credits: Double, summary: TaxSummary) {
        self.state = state
        self.attributableIncome = attributableIncome
        self.taxes = taxes
        self.localTax = localTax
        self.taxableStateIncome = taxableStateIncome
        self.additionalStateIncome = additionalStateIncome
        self.deduction = deduction
        self.withholdings = withholdings
        self.credits = credits
        self.summary = summary
    }
}

public struct CalculatedTaxData: Identifiable, Hashable {
    public var id = UUID()

    public let inputData: TaxDataInput
    public let federalData: FederalTaxData
    public let stateTaxDatas: [StateTaxData]
    public let statesSummary: TaxSummary
    public var totalSummary: TaxSummary

    // convenience getters
    public var title: String { inputData.title }
    public var taxYear: TaxYear { inputData.taxYear }
    public var filingType: FilingType { inputData.filingType }
    public var income: Income { inputData.income }
    public var totalIncome: Double { inputData.income.totalIncome }

    public init(inputData: TaxDataInput, federalData: FederalTaxData, stateTaxDatas: [StateTaxData], statesSummary: TaxSummary, totalSummary: TaxSummary) {
        self.inputData = inputData
        self.federalData = federalData
        self.stateTaxDatas = stateTaxDatas
        self.statesSummary = statesSummary
        self.totalSummary = totalSummary
    }

    public static func == (lhs: CalculatedTaxData, rhs: CalculatedTaxData) -> Bool {
        lhs.inputData == rhs.inputData
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
