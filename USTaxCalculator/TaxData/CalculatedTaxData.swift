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

    let title: String
    let filingType: FilingType
    let taxYear: TaxYear

    let income: Income
    let federal: FederalTaxData
    let stateTaxes: [StateTax]
    let taxSummaries: TaxSummaries

    let inputData: TaxDataInput

    init(_ input: TaxDataInput) {
        title = input.title
        filingType = input.filingType
        taxYear = input.taxYear
        income = input.income
        inputData = input

        let taxRates = taxYear.rawTaxRatesForFilingType(filingType)
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
