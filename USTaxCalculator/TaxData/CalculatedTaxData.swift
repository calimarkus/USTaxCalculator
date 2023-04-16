//
// CalculatedTaxData.swift
//

import SwiftUI

struct FederalTaxData {
    let taxableIncome: Double
    let deductions: Double
    let credits: Double
    let taxes: [FederalTax]
}

struct CalculatedTaxData: Identifiable, Hashable {
    var id = UUID()

    let inputData: TaxDataInput
    let federalData: FederalTaxData
    let stateTaxes: [StateTax]
    let taxSummaries: TaxSummaries

    // convenience getters
    var title: String { inputData.title }
    var taxYear: TaxYear { inputData.taxYear }
    var filingType: FilingType { inputData.filingType }
    var income: Income { inputData.income }
    var totalIncome: Double { inputData.income.totalIncome }

    init(_ input: TaxDataInput) {
        inputData = input

        let taxRates = RawTaxRatesYear.taxRatesYearFor(input.taxYear, input.filingType)
        federalData = TaxFactory.federalTaxesFor(
            income: input.income,
            federalDeductions: input.federalDeductions,
            federalCredits: input.federalCredits,
            taxRates: taxRates.federalRates
        )

        stateTaxes = input.income.stateIncomes.map {
            TaxFactory.stateTaxFor(
                stateIncome: $0,
                stateDeductions: input.stateDeductions,
                stateCredits: input.stateCredits,
                totalIncome: input.income.totalIncome,
                taxRates: taxRates
            )
        }

        taxSummaries = TaxSummaries.calculateFor(
            input: input,
            federalTaxes: federalData.taxes,
            stateTaxes: stateTaxes
        )
    }

    static func == (lhs: CalculatedTaxData, rhs: CalculatedTaxData) -> Bool {
        lhs.inputData == rhs.inputData
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func formattedTitle() -> String {
        title.count > 0 ? title : FormattingHelper.formattedTitle(taxdata: self)
    }
}
