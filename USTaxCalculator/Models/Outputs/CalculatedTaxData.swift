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
}

struct StateTaxData {
    let state: TaxState /// The underlying state
    let tax: StateTax

    let additionalStateIncome: Double /// State Income that's not part of the wages on the W-2
    let deduction: Deduction /// Deductions that apply to this state
    let withholdings: Double /// Withholdings that apply to this state
    let credits: Double /// Credits that apply to this state
}

struct CalculatedTaxData: Identifiable, Hashable {
    var id = UUID()

    let inputData: TaxDataInput
    let federalData: FederalTaxData
    let stateTaxDatas: [StateTaxData]
    let taxSummaries: TaxSummaries

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
