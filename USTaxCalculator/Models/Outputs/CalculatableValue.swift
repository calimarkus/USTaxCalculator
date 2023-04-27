//
// CalculatableValue.swift
//

import Foundation

enum ExplanationType {
    case names
    case values
}

protocol CalculatableValue {
    func calculate() -> Double
    func calculationExplanation(as type: ExplanationType) -> String
}
