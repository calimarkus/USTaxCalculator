//
// ExplainableValue.swift
//

import Foundation

enum ExplanationType {
    case names
    case values
}

protocol ExplainableValue {
    func calculationExplanation(as type: ExplanationType) -> String
}
