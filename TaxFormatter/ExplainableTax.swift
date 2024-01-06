//
//

import TaxModels

public protocol ExplainableTax: Tax, ExplainableValue {}

extension BasicTax: ExplainableTax {
    /// A string explaining how the tax amount was calculated
    public func calculationExplanation(as type: ExplanationType) -> String {
        activeBracket.taxCalculationExplanation(for: taxableIncome, explanationType: type)
    }
}

extension AttributableTax: ExplainableTax {
    /// A string explaining how the tax amount was calculated
    public func calculationExplanation(as type: ExplanationType) -> String {
        activeBracket.taxCalculationExplanation(
            for: taxableIncome,
            explanationType: type,
            attributedRate: attributedRate.amount < 1.0 ? attributedRate : nil
        )
    }
}
