//
//

struct CalculatedTaxData {
    let title: String
    let filingType: FilingType
    let taxYear: TaxYear

    let income: Income
    let taxableFederalIncome: Double
    let federalDeductions: Double

    let allFederalTaxes: [FederalTax]
    let stateTaxes: [StateTax]
    let stateCredits: [TaxState: Double]
    let taxSummaries: TaxSummaries

    let input: TaxDataInput

    init(_ input: TaxDataInput) throws {
        title = input.title
        filingType = input.filingType
        taxYear = input.taxYear
        income = input.income
        stateCredits = input.stateCredits
        self.input = input

        federalDeductions = DeductionAmount.federalAmount(input.federalDeductions, taxYear: taxYear, filingType: filingType)
        taxableFederalIncome = max(0.0, income.totalIncome - income.longtermCapitalGains - federalDeductions)

        // build federal taxes
        allFederalTaxes = try TaxFactory.federalTaxesFor(income: income,
                                                         taxableFederalIncome: taxableFederalIncome,
                                                         taxYear: taxYear,
                                                         filingType: filingType)

        // build state taxes
        stateTaxes = try income.stateIncomes.map { stateIncome in
            try TaxFactory.stateTaxFor(stateIncome: stateIncome,
                                       stateDeductions: input.stateDeductions,
                                       totalIncome: input.income.totalIncome,
                                       taxYear: input.taxYear,
                                       filingType: input.filingType)
        }

        // calculate tax summaries
        taxSummaries = TaxSummaries.calculateFor(totalFederalIncome: income.totalIncome,
                                                 taxableFederalIncome: taxableFederalIncome,
                                                 federalWithholdings: income.federalWithholdings + input.additionalFederalWithholding,
                                                 federalCredits: input.federalCredits,
                                                 federalTaxes: allFederalTaxes,
                                                 stateTaxes: stateTaxes,
                                                 stateCredits: stateCredits)
    }
}
