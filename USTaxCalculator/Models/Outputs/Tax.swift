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
}

extension BasicTax {
    func calculationExplanation(as type: ExplanationType) -> String {
        activeBracket.taxCalculationExplanation(for: taxableIncome, explanationType: type)
    }
}

struct StateTax: Tax {
    /// The name of this tax
    let title: String

    /// The active TaxBracket
    let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    let bracketGroup: TaxBracketGroup

    /// The taxable income for this state
    let taxableIncome: NamedValue

    /// The taxes coming from this state
    /// see https://turbotax.intuit.com/tax-tips/state-taxes/multiple-states-figuring-whats-owed-when-you-live-and-work-in-more-than-one-state/L79OKm3jI
    /// using "Common method 1" for multi state taxes
    var taxAmount: Double {
        activeBracket.calculateTaxes(for: taxableIncome) * stateAttributedIncome.rate
    }

    /// The income attributed to this state (only relevant in multi state situations)
    let stateAttributedIncome: StateAttributedIncome

    /// An additional optional local tax applying to this state
    var localTax: BasicTax?
}

extension StateTax: ExplainableValue {
    func calculationExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                let bracketInfo = activeBracket.taxCalculationExplanation(for: taxableIncome, explanationType: .names)
                if stateAttributedIncome.rate < 1.0 {
                    return "(\(bracketInfo)) * State Income Rate"
                }
                return bracketInfo
            case .values:
                if stateAttributedIncome.rate < 1.0 {
                    let bracketInfo = activeBracket.taxCalculationExplanation(for: taxableIncome, includeTotalValue: false)
                    return "(\(bracketInfo)) * \(FormattingHelper.formatPercentage(stateAttributedIncome.rate)) = \(FormattingHelper.formatCurrency(taxAmount))"
                }
                return activeBracket.taxCalculationExplanation(for: taxableIncome, includeTotalValue: true)
        }
    }
}
