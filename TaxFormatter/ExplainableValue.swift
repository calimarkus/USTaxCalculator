//
// ExplainableValue.swift
//

import Foundation

public enum ExplanationType {
    case names
    case values
}

public protocol ExplainableValue {
    func calculationExplanation(as type: ExplanationType) -> String
}
