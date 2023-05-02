//
// CalculatedTaxData.swift
//

import SwiftUI

struct FederalTaxData {
    let taxes: [BasicTax]

    let totalTaxableIncome: Double
    let totalTaxes: Double

    let deduction: Deduction
    let withholdings: Double
    let credits: Double

    let summary: TaxSummary
}

struct StateTaxData {
    let state: TaxState /// The underlying state
    let attributableIncome: AttributableIncome /// The income attributed to this state (only relevant in multi state situations)
    let taxes: [AttributableTax]
    var localTax: BasicTax? /// An additional optional local tax applying to this state

    let taxableStateIncome: NamedValue
    let additionalStateIncome: Double /// State Income that's not part of the wages on the W-2
    let deduction: Deduction /// Deductions that apply to this state
    let withholdings: Double /// Withholdings that apply to this state
    let credits: Double /// Credits that apply to this state

    let summary: TaxSummary
}

struct CalculatedTaxData: Identifiable, Hashable {
    var id = UUID()

    let inputData: TaxDataInput
    let federalData: FederalTaxData
    let stateTaxDatas: [StateTaxData]
    let statesSummary: TaxSummary
    var totalSummary: TaxSummary

    // convenience getters
    var title: String { inputData.title }
    var taxYear: TaxYear { inputData.taxYear }
    var filingType: FilingType { inputData.filingType }
    var income: Income { inputData.income }
    var totalIncome: Double { inputData.income.totalIncome }

    static func == (lhs: CalculatedTaxData, rhs: CalculatedTaxData) -> Bool {
        lhs.inputData == rhs.inputData
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
