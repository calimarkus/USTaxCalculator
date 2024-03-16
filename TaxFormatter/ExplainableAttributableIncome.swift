//
// ExplainableAttributableIncome.swift
//

import TaxModels

extension AttributableIncome: ExplainableValue {
    /// An explanation of how the rate was calculated
    public func calculationExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                return "\(incomeName) / \(totalIncome.name)"
            case .values:
                var explanation = "\(FormattingHelper.formatCurrency(amount)) / \(FormattingHelper.formatCurrency(totalIncome.amount))"
                explanation += " = \(FormattingHelper.formatPercentage(rate.amount))"
                return explanation
        }
    }
}
