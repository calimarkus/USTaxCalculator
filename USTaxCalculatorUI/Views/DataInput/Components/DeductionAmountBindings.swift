//
// DeductionAmountBindings.swift
//

import SwiftUI
import TaxOutputModels

extension DeductionKind {
    static func pickerSelectionBinding(_ deduction: Binding<DeductionKind>) -> Binding<DeductionKind> {
        Binding {
            switch deduction.wrappedValue {
                case .standard: return .standard(additionalDeductions: 0.0)
                case .custom: return .custom(0.0)
            }
        } set: { val in
            deduction.wrappedValue = val
        }
    }

    static func valueBinding(_ deduction: Binding<DeductionKind>, isCustomDeduction: Bool) -> Binding<Double> {
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
