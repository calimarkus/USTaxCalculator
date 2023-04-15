//
//

import Foundation
import SwiftUI

struct FederalTaxData {
    let taxableIncome: Double
    let deductions: Double
    let credits: Double
    let taxes: [FederalTax]

    init(_ input: TaxDataInput, taxRates: FederalTaxRates, filingType: FilingType) throws {
        let income = input.income
        deductions = try DeductionsFactory.calculateDeductionsForDeductionAmount(input.federalDeductions, standardDeduction: taxRates.standardDeductions[filingType])
        credits = input.federalCredits
        taxableIncome = max(0.0, income.totalIncome - income.longtermCapitalGains - deductions)

        // build federal taxes
        taxes = try TaxFactory.federalTaxesFor(income: income,
                                               taxableFederalIncome: NamedValue(amount: taxableIncome, name: "Taxable Income"),
                                               taxRates: taxRates,
                                               filingType: filingType)
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

    let input: TaxDataInput

    init(_ input: TaxDataInput) throws {
        title = input.title
        filingType = input.filingType
        taxYear = input.taxYear
        let taxRates = taxYear.rawTaxRates()

        income = input.income
        federal = try FederalTaxData(input, taxRates: taxRates.federalRates, filingType: filingType)
        self.input = input

        // build state taxes
        stateTaxes = try input.income.stateIncomes.map { stateIncome in
            try TaxFactory.stateTaxFor(stateIncome: stateIncome,
                                       stateDeductions: input.stateDeductions,
                                       stateCredits: input.stateCredits,
                                       totalIncome: input.income.totalIncome,
                                       taxRates: taxRates,
                                       filingType: input.filingType)
        }

        // calculate tax summaries
        taxSummaries = TaxSummaries.calculateFor(input: input,
                                                 federalTaxes: federal.taxes,
                                                 stateTaxes: stateTaxes)
    }

    static func == (lhs: CalculatedTaxData, rhs: CalculatedTaxData) -> Bool {
        return lhs.input == rhs.input
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func formattedTitle() -> String {
        return title.count > 0 ? title : FormattingHelper.formattedTitle(taxdata: self)
    }
}
