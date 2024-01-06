//
// Deduction.swift
//

import Foundation
import TaxRates

public enum DeductionKind: Hashable, Codable, Equatable {
    case standard(additionalDeductions: Double = 0.0)
    case custom(_ amount: Double)
}

public struct Deduction {
    public var kind: DeductionKind
    public var standardDeduction: RawStandardDeduction

    public init(kind: DeductionKind, standardDeduction: RawStandardDeduction) {
        self.kind = kind
        self.standardDeduction = standardDeduction
    }

    /// returns the deduction amount
    public var amount: Double {
        switch kind {
            case let .standard(additional): return additional + standardDeduction.value
            case let .custom(customAmount): return customAmount
        }
    }

    /// The original sources of the deduction amount
    public var sources: [URL] {
        switch kind {
            case .standard:
                return standardDeduction.sources
            case .custom:
                return []
        }
    }
}
