//
// DeductionAmountBindings.swift
//

import SwiftUI

extension DeductionInput {
    static func pickerSelectionBinding(_ deduction: Binding<DeductionInput>) -> Binding<DeductionInput> {
        Binding {
            switch deduction.wrappedValue {
                case .standard: return .standard(additionalDeductions: 0.0)
                case .custom: return .custom(0.0)
            }
        } set: { val in
            deduction.wrappedValue = val
        }
    }

    static func valueBinding(_ deduction: Binding<DeductionInput>, isCustomDeduction: Bool) -> Binding<Double> {
        Binding {
            switch deduction.wrappedValue {
                case let .standard(val): return val
                case let .custom(val): return val
            }
        } set: { val in
            deduction.wrappedValue = isCustomDeduction ? .custom(val) : .standard(additionalDeductions: val)
        }
    }
}
