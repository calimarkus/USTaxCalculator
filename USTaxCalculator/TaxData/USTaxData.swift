//
//

enum TaxYear : Int {
    case y2020 = 2020
    case y2021 = 2021
}

enum FilingType : String {
    case single = "Single"
    case marriedJointly = "Jointly"
}

struct USTaxData {
    let title: String?
    let filingType: FilingType
    let taxYear: TaxYear

    let income: Income
    let taxableFederalIncome: Double
    let federalDeductions: Double

    let allFederalTaxes: [FederalTax]
    let stateTaxes: [StateTax]
    let stateCredits: [State: Double]
    let taxSummaries:TaxSummaries

    init (
        /// An additional description for this data, which will be combined with the default title if provided like e.g. "title - Year 2021 (Single, NY+CA)"
        title:String?,
        /// true if the taxes are filed jointly as a married couple, otherwise single is assumed
        filingType: FilingType,
        /// the tax year for these taxes
        taxYear:TaxYear,
        /// The Income to use in the calculations
        income: Income,

        /// Federal withholdings not listed on the W-2 (e.g. estimated payments, etc.)
        additionalFederalWithholding: Double,
        /// Tax credits that apply to your state taxes
        stateCredits: [State: Double],
        /// Tax credits that apply to your federal taxes
        federalCredits: Double,
        /// Federal deductions that apply. .standard will utilize standard deductions
        federalDeductions: DeductionAmount
    ) throws {
        self.title = title
        self.filingType = filingType
        self.taxYear = taxYear
        self.income = income
        self.stateCredits = stateCredits

        self.federalDeductions = DeductionAmount.federalAmount(amount: federalDeductions, taxYear: taxYear, filingType: filingType)
        self.taxableFederalIncome = income.totalIncome - income.longtermCapitalGains - self.federalDeductions

        // build federal taxes
        self.allFederalTaxes = try TaxFactory.federalTaxesFor(income: income,
                                                              taxableFederalIncome: self.taxableFederalIncome,
                                                              taxYear: taxYear,
                                                              filingType:filingType)

        // build state taxes
        self.stateTaxes = try income.stateIncomes.map { stateIncome in
            return try TaxFactory.stateTaxFor(stateIncome: stateIncome,
                                              totalIncome: income.totalIncome,
                                              taxYear: taxYear,
                                              filingType: filingType)
        }

        // calculate tax summaries
        self.taxSummaries = TaxSummaries.calculateFor(totalFederalIncome:income.totalIncome,
                                                      taxableFederalIncome: taxableFederalIncome,
                                                      federalWithholdings: income.federalWithholdings + additionalFederalWithholding,
                                                      federalCredits: federalCredits,
                                                      federalTaxes: allFederalTaxes,
                                                      stateTaxes: stateTaxes,
                                                      stateCredits: stateCredits)
    }
}
