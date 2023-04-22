//
// Deduction.swift
//

import Foundation

struct Deduction {
    private var input: DeductionInput
    private var standardDeduction: RawStandardDeduction

    init(input: DeductionInput, standardDeduction: RawStandardDeduction) {
        self.input = input
        self.standardDeduction = standardDeduction
    }

    /// The original sources of the deduction amount
    var sources: [URL] {
        switch input {
            case .standard:
                return standardDeduction.sources
            case .custom:
                return []
        }
    }
}

extension Deduction: CalculatableValue {
    /// returns the deduction amount
    func calculateAmount() -> Double {
        switch input {
            case let .standard(additional): return additional + standardDeduction.value
            case let .custom(customAmount): return customAmount
        }
    }

    /// returns a string describing the calculation of the deduction
    func calculationExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                switch input {
                    case let .standard(additional):
                        return additional > 0 ? "Standard Deduction + Additional Amount" : "Standard Deduction"
                    case .custom:
                        return "Custom Amount"
                }
            case .values:
                switch input {
                    case let .standard(additional):
                        let standardFormatted = FormattingHelper.formatCurrency(standardDeduction.value)
                        let additionalFormatted = FormattingHelper.formatCurrency(additional)
                        let total = FormattingHelper.formatCurrency(calculateAmount())
                        return additional > 0 ? "\(standardFormatted) + \(additionalFormatted) = \(total)" : standardFormatted
                    case let .custom(customAmount):
                        return FormattingHelper.formatCurrency(customAmount)
                }
        }
    }
}
