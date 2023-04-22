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
}
