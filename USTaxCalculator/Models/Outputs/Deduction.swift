//
// Deduction.swift
//

import Foundation

struct Deduction {
    /// The name of this deduction
    let title: String

    private var input: DeductionInput
    private var standardDeduction: RawStandardDeduction

    init(title: String, input: DeductionInput, standardDeduction: RawStandardDeduction) {
        self.title = title
        self.input = input
        self.standardDeduction = standardDeduction
    }

    /// returns the deduction amount
    var amount: NamedValue {
        NamedValue(amount: calculateAmount(), name: title)
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

    private func calculateAmount() -> Double {
        switch input {
            case let .standard(additional): return additional + standardDeduction.value
            case let .custom(customAmount): return customAmount
        }
    }

    /// returns a string describing the calculation of the deduction
    func calculationExplanation(explanationType: ExplanationType = .values) -> String {
        switch explanationType {
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
                        return additional > 0 ? "\(standardFormatted) + \(additionalFormatted)" : standardFormatted
                    case let .custom(customAmount):
                        return FormattingHelper.formatCurrency(customAmount)
                }
        }
    }
}
