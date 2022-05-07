//
//

protocol Tax {
    /// The tax amount
    var taxAmount: Double { get }

    /// The underlying TaxBracket
    var bracket: TaxBracket { get }

    /// The taxable income for this specific Bracket
    var taxableIncome: Double { get }
}

struct FederalTax: Tax {
    /// The name of this tax
    let title: String

    /// The underlying TaxBracket
    let bracket: TaxBracket

    /// The taxable income for this specific Bracket
    let taxableIncome: Double

    /// The taxes coming from this bracket
    var taxAmount: Double { return bracket.calculateTaxesForAmount(taxableIncome) }
}

struct StateTax: Tax {
    /// The underlying state
    let state: TaxState

    /// The underlying TaxBracket
    let bracket: TaxBracket

    /// An additional local tax applying to this state
    var localTax: LocalTax? = nil

    /// The taxable income for this specific Bracket
    let taxableIncome: Double

    /// Deductions that apply to this bracket
    let deductions: Double

    /// Withholdings that apply to this bracket
    let withholdings: Double

    /// The income rate for this bracket (only relevant in multi state situations)
    var incomeRate: Double = 1.0

    /// The taxes coming from this bracket AND the local bracket
    var taxAmount: Double { return stateOnlyTaxAmount + (localTax?.taxAmount ?? 0.0) }

    /// The taxes coming from this bracket
    /// see https://turbotax.intuit.com/tax-tips/state-taxes/multiple-states-figuring-whats-owed-when-you-live-and-work-in-more-than-one-state/L79OKm3jI
    /// using "Common method 1" for multi state taxes
    var stateOnlyTaxAmount: Double { return bracket.calculateTaxesForAmount(taxableIncome) * incomeRate }
}

struct LocalTax: Tax {
    /// The underlying city
    let city: TaxCity

    /// The underlying TaxBracket
    let bracket: TaxBracket

    /// The taxable income for this specific Bracket
    let taxableIncome: Double

    /// The taxes coming from this bracket
    var taxAmount: Double { return bracket.calculateTaxesForAmount(taxableIncome) }
}
