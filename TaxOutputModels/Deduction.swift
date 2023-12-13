//
// Deduction.swift
//

import Foundation
import TaxInputModels
import TaxRates

public struct Deduction {
    public var input: DeductionInput
    public var standardDeduction: RawStandardDeduction

    public init(input: DeductionInput, standardDeduction: RawStandardDeduction) {
        self.input = input
        self.standardDeduction = standardDeduction
    }

    /// returns the deduction amount
    public var amount: Double {
        switch input {
            case let .standard(additional): return additional + standardDeduction.value
            case let .custom(customAmount): return customAmount
        }
    }

    /// The original sources of the deduction amount
    public var sources: [URL] {
        switch input {
            case .standard:
                return standardDeduction.sources
            case .custom:
                return []
        }
    }
}
