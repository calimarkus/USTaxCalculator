//
//

import Foundation
import SwiftUI

struct FederalTaxData {
    let taxableIncome: Double
    let deductions: Double
    let credits: Double
    let taxes: [FederalTax]

    init(_ input: TaxDataInput, taxRates: FederalTaxRates) {
        deductions = DeductionsFactory.calculateDeductionsForDeductionAmount(
            input.federalDeductions,
            standardDeduction: taxRates.standardDeductions
        )

        credits = input.federalCredits
        taxableIncome = max(0.0, input.income.totalIncome - input.income.longtermCapitalGains - deductions)

        taxes = TaxFactory.federalTaxesFor(
            income: input.income,
            taxableFederalIncome: NamedValue(amount: taxableIncome, name: "Taxable Income"),
            taxRates: taxRates
        )
    }
}

struct CalculatedTaxData: Identifiable, Hashable {
    var id = UUID()

    let inputData: TaxDataInput
    let federal: FederalTaxData
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
        federal = FederalTaxData(input, taxRates: taxRates.federalRates)

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
            federalTaxes: federal.taxes,
            stateTaxes: stateTaxes
        )
    }

    static func == (lhs: CalculatedTaxData, rhs: CalculatedTaxData) -> Bool {
        return lhs.inputData == rhs.inputData
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func formattedTitle() -> String {
        return title.count > 0 ? title : FormattingHelper.formattedTitle(taxdata: self)
    }
}
