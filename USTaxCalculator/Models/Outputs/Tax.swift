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

    /// The tax amount
    var taxAmount: Double { get }

    /// The active TaxBracket
    var activeBracket: TaxBracket { get }

    /// The underlying TaxBracketGroup
    var bracketGroup: TaxBracketGroup { get }

    /// The taxable income for this specific Bracket
    var taxableIncome: NamedValue { get }
}

extension Tax {
    func calculationExplanation(as type: ExplanationType) -> String {
        activeBracket.taxCalculationExplanation(taxableIncome, explanationType: type)
    }
}

struct FederalTax: Tax {
    /// The name of this tax
    let title: String

    /// The active TaxBracket
    let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    let bracketGroup: TaxBracketGroup

    /// The taxable income for this specific Bracket
    let taxableIncome: NamedValue

    /// The taxes coming from this bracket
    var taxAmount: Double { activeBracket.calculateTaxesForAmount(taxableIncome) }
}

struct StateTax: Tax {
    /// A generated title
    var title: String { "\(state) State" }

    /// The underlying state
    let state: TaxState

    /// The active TaxBracket
    let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    let bracketGroup: TaxBracketGroup

    /// An additional local tax applying to this state
    var localTax: LocalTax? = nil

    /// The taxable income for this state
    let taxableIncome: NamedValue

    /// The income attributed to this state (only relevant in multi state situations)
    var stateAttributedIncome: StateAttributedIncome

    /// The taxes coming from this bracket AND the local bracket
    var taxAmount: Double { stateOnlyTaxAmount + (localTax?.taxAmount ?? 0.0) }

    /// The taxes coming from this bracket
    /// see https://turbotax.intuit.com/tax-tips/state-taxes/multiple-states-figuring-whats-owed-when-you-live-and-work-in-more-than-one-state/L79OKm3jI
    /// using "Common method 1" for multi state taxes
    var stateOnlyTaxAmount: Double {
        activeBracket.calculateTaxesForAmount(taxableIncome) * stateAttributedIncome.rate
    }

    func stateOnlyTaxExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                let bracketInfo = activeBracket.taxCalculationExplanation(taxableIncome, explanationType: .names)
                if stateAttributedIncome.rate < 1.0 {
                    return "(\(bracketInfo)) * State Income Rate"
                }
                return bracketInfo
            case .values:
                if stateAttributedIncome.rate < 1.0 {
                    let bracketInfo = activeBracket.taxCalculationExplanation(taxableIncome, includeTotalValue: false)
                    return "(\(bracketInfo)) * \(FormattingHelper.formatPercentage(stateAttributedIncome.rate)) = \(FormattingHelper.formatCurrency(stateOnlyTaxAmount))"
                }
                return activeBracket.taxCalculationExplanation(taxableIncome, includeTotalValue: true)
        }
    }
}

extension StateTax: ExplainableValue {
    func calculationExplanation(as type: ExplanationType) -> String { stateOnlyTaxExplanation(as: type) }
}

struct LocalTax: Tax {
    /// A generated title
    var title: String { "\(city) Local" }

    /// The underlying city
    let city: TaxCity

    /// The active TaxBracket
    let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    let bracketGroup: TaxBracketGroup

    /// The taxable income for this specific Bracket
    let taxableIncome: NamedValue

    /// The taxes coming from this bracket
    var taxAmount: Double { activeBracket.calculateTaxesForAmount(taxableIncome) }
}
