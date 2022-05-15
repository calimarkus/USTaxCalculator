//
//

import Foundation

struct FederalTaxData {
    let taxableIncome: Double
    let deductions: Double
    let taxes: [FederalTax]

    init(_ input: TaxDataInput, taxYear: TaxYear, filingType: FilingType) throws {
        let income = input.income
        deductions = DeductionAmount.federalAmount(input.federalDeductions, taxYear: taxYear, filingType: filingType)
        taxableIncome = max(0.0, income.totalIncome - income.longtermCapitalGains - deductions)

        // build federal taxes
        taxes = try TaxFactory.federalTaxesFor(income: income,
                                               taxableFederalIncome: taxableIncome,
                                               taxYear: taxYear,
                                               filingType: filingType)
    }
}

struct CalculatedTaxData: Identifiable {
    let id = UUID()

    let title: String
    let filingType: FilingType
    let taxYear: TaxYear

    let income: Income
    let federal: FederalTaxData
    let stateTaxes: [StateTax]
    let stateCredits: [TaxState: Double]
    let taxSummaries: TaxSummaries

    let input: TaxDataInput

    init(_ input: TaxDataInput) throws {
        title = input.title
        filingType = input.filingType
        taxYear = input.taxYear

        income = input.income
        federal = try FederalTaxData(input, taxYear: taxYear, filingType: filingType)
        stateCredits = input.stateCredits
        self.input = input

        // build state taxes
        stateTaxes = try input.income.stateIncomes.map { stateIncome in
            try TaxFactory.stateTaxFor(stateIncome: stateIncome,
                                       stateDeductions: input.stateDeductions,
                                       totalIncome: input.income.totalIncome,
                                       taxYear: input.taxYear,
                                       filingType: input.filingType)
        }

        // calculate tax summaries
        taxSummaries = TaxSummaries.calculateFor(input: input,
                                                 federalTaxes: federal.taxes,
                                                 stateTaxes: stateTaxes,
                                                 stateCredits: stateCredits)
    }
}
