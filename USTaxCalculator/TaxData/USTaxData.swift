//
//

enum TaxYear: Int {
    case y2020 = 2020
    case y2021 = 2021
}

enum FilingType: String, CaseIterable {
    case single = "Single"
    case marriedJointly = "Jointly"
}

struct TaxDataInput {
    /// An additional description for this data, which will be combined with the default title if provided like e.g. "title - Year 2021 (Single, NY+CA)"
    var title: String = ""
    /// true if the taxes are filed jointly as a married couple, otherwise single is assumed
    var filingType: FilingType = .single
    /// the tax year for these taxes
    var taxYear: TaxYear = .y2021
    /// The Income to use in the calculations
    var income: Income = Income()

    /// Federal deductions that apply.
    var federalDeductions: DeductionAmount = .standard()
    /// State deductions that apply to each state. Missing states will utilize standard deductions.
    var stateDeductions: [TaxState: DeductionAmount] = [:]

    /// Federal withholdings not listed on the W-2 (e.g. estimated payments, etc.)
    var additionalFederalWithholding: Double = 0.0

    /// Tax credits that apply to your federal taxes
    var federalCredits: Double = 0.0
    /// Tax credits that apply to your state taxes
    var stateCredits: [TaxState: Double] = [:]
}

struct USTaxData {
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

    init(_ input: TaxDataInput) throws {
        title = input.title
        filingType = input.filingType
        taxYear = input.taxYear
        income = input.income
        stateCredits = input.stateCredits

        federalDeductions = DeductionAmount.federalAmount(input.federalDeductions, taxYear: taxYear, filingType: filingType)
        taxableFederalIncome = income.totalIncome - income.longtermCapitalGains - federalDeductions

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
