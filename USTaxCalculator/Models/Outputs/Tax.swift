//
// Tax.swift
//

struct NamedValue {
    let amount: Double
    let name: String
}

protocol Tax: ExplainableValue {
    /// The title for this tax
    var title: String { get }

    /// The active TaxBracket
    var activeBracket: TaxBracket { get }

    /// The underlying TaxBracketGroup
    var bracketGroup: TaxBracketGroup { get }

    /// The taxable income for this specific Bracket
    var taxableIncome: NamedValue { get }

    /// The tax amount
    var taxAmount: Double { get }
}

struct BasicTax: Tax {
    /// The name of this tax
    let title: String

    /// The active TaxBracket
    let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    let bracketGroup: TaxBracketGroup

    /// The taxable income for this specific Bracket
    let taxableIncome: NamedValue

    /// The taxes coming from this bracket
    var taxAmount: Double { activeBracket.calculateTaxes(for: taxableIncome) }

    /// A string explaining how the tax amount was calculated
    func calculationExplanation(as type: ExplanationType) -> String {
        activeBracket.taxCalculationExplanation(for: taxableIncome, explanationType: type)
    }
}

/// See this source: https://turbotax.intuit.com/tax-tips/state-taxes/multiple-states-figuring-whats-owed-when-you-live-and-work-in-more-than-one-state/L79OKm3jI
/// It is currently using the "Common method 1" for multi state taxes.
struct AttributableTax: Tax {
    /// The name of this tax
    let title: String

    /// The active TaxBracket
    let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    let bracketGroup: TaxBracketGroup

    /// The taxable income for this state
    let taxableIncome: NamedValue

    /// The rate of the taxable income, which this tax applies to
    let attributableRate: NamedValue

    /// The taxes coming from this state
    var taxAmount: Double {
        activeBracket.calculateTaxes(for: taxableIncome) * attributableRate.amount
    }

    /// A string explaining how the tax amount was calculated
    func calculationExplanation(as type: ExplanationType) -> String {
        activeBracket.taxCalculationExplanation(
            for: taxableIncome,
            explanationType: type,
            attributableRate: attributableRate.amount < 1.0 ? attributableRate : nil
        )
    }
}
