//
//

import TaxModels

// tax calculation explanation
public extension TaxBracket {
    /// returns a string describing the calculation of the taxes for the given amount, respecting the bracket type
    func taxCalculationExplanation(for namedTaxableAmount: NamedValue, explanationType: ExplanationType = .values, attributedRate: NamedValue? = nil) -> String {
        switch explanationType {
            case .names:
                var explanation = namedExplanationWithoutSum(for: namedTaxableAmount)
                if let attributedRate {
                    explanation += " * \(attributedRate.name)"
                }
                return explanation

            case .values:
                var explanation = valueExplanationWithoutSum(for: namedTaxableAmount)
                if let attributedRate {
                    explanation += " * \(FormattingHelper.formatPercentage(attributedRate.amount))"
                }
                explanation += " = \(FormattingHelper.formatCurrency(calculateTaxes(for: namedTaxableAmount, attributableRate: attributedRate)))"
                return explanation
        }
    }

    private func namedExplanationWithoutSum(for namedTaxableAmount: NamedValue) -> String {
        switch type {
            case .basic:
                return "\(namedTaxableAmount.name) * Rate"
            case .interpolated:
                return "\(namedTaxableAmount.name) * (lower rate + (higher rate - lower rate) / 2.0))"
            case let .progressive(fixedAmount):
                let fixedAmountDesc = fixedAmount > 0.0 ? " + Fixed amount" : ""
                return "(\(namedTaxableAmount.name) - Bracket start) * Rate\(fixedAmountDesc)"
        }
    }

    private func valueExplanationWithoutSum(for namedTaxableAmount: NamedValue) -> String {
        switch type {
            case .basic:
                return "\(FormattingHelper.formatCurrency(namedTaxableAmount.amount)) * \(FormattingHelper.formatPercentage(rate))"
            case let .interpolated(lowerBracket, higherBracket):
                return "\(FormattingHelper.formatCurrency(namedTaxableAmount.amount)) * (\(FormattingHelper.formatPercentage(lowerBracket.rate)) + (\(FormattingHelper.formatPercentage(lowerBracket.rate)) - \(FormattingHelper.formatPercentage(higherBracket.rate))) / 2.0)"
            case let .progressive(fixedAmount):
                let fixedAmountText = fixedAmount > 0.0 ? " + \(FormattingHelper.formatCurrency(fixedAmount))" : ""
                return "(\(FormattingHelper.formatCurrency(namedTaxableAmount.amount)) - \(FormattingHelper.formatCurrency(startingAt))) * \(FormattingHelper.formatPercentage(rate))\(fixedAmountText)"
        }
    }
}
