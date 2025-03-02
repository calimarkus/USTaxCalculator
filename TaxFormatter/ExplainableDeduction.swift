//
// ExplainableDeduction.swift
//

import TaxModels

extension Deduction: @retroactive ExplainableValue {
    /// a string describing the calculation of the deduction
    public func calculationExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                switch kind {
                    case let .standard(additional):
                        return additional > 0 ? "Standard Deduction + Additional Amount" : "Standard Deduction"
                    case .custom:
                        return "Custom Amount"
                }
            case .values:
                switch kind {
                    case let .standard(additional):
                        let standardFormatted = FormattingHelper.formatCurrency(standardDeduction.value)
                        let additionalFormatted = FormattingHelper.formatCurrency(additional)
                        let total = FormattingHelper.formatCurrency(amount)
                        return additional > 0 ? "\(standardFormatted) + \(additionalFormatted) = \(total)" : standardFormatted
                    case let .custom(customAmount):
                        return FormattingHelper.formatCurrency(customAmount)
                }
        }
    }
}
