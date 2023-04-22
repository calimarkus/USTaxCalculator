//
// CalculatableValue.swift
//

import Foundation

enum ExplanationType {
    case names
    case values
}

protocol CalculatableValue {
    func calculateAmount() -> Double
    func calculationExplanation(as type: ExplanationType) -> String
    func formattedAmount() -> String
}

extension CalculatableValue {
    func formattedAmount() -> String {
        FormattingHelper.formatCurrency(calculateAmount())
    }
}
