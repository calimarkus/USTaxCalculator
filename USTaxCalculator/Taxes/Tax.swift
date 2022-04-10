//
//

protocol ExplainableTaxAmountProvider {
    /// The tax amount
    var taxAmount:Double { get }

    /// An explanation how the taxes were calculated
    var taxCalculationExplanation:String { get }
}

struct FederalTax : ExplainableTaxAmountProvider {
    /// The name of this tax
    let title:String

    /// The underlying TaxBracket
    let bracket:TaxBracket

    /// The taxable income for this specific Bracket
    let taxableIncome:Double

    /// The taxes coming from this bracket
    var taxAmount:Double { return bracket.calculateTaxesForAmount(taxableIncome) }

    /// An explanation how the taxes were calculated
    var taxCalculationExplanation:String { return bracket.taxCalculationExplanation(taxableIncome) }
}

struct StateTax : ExplainableTaxAmountProvider {
    /// The underlying state
    let state:StateOrCity

    /// The underlying TaxBracket
    let bracket:TaxBracket

    /// The taxable income for this specific Bracket
    let taxableIncome:Double

    /// Deductions that apply to this bracket
    let deductions:Double

    /// Withholdings that apply to this bracket
    let withholdings:Double

    /// The income rate for this bracket (only relevant in multi state situations)
    var incomeRate:Double=1.0

    /// The taxes coming from this bracket
    /// see https://turbotax.intuit.com/tax-tips/state-taxes/multiple-states-figuring-whats-owed-when-you-live-and-work-in-more-than-one-state/L79OKm3jI
    /// using "Common method 1" for multi state taxes
    var taxAmount:Double { return bracket.calculateTaxesForAmount(taxableIncome) * incomeRate }

    /// An explanation how the taxes were calculated
    var taxCalculationExplanation:String { return "(\(bracket.taxCalculationExplanation(taxableIncome))) * \(incomeRate)" }
}
