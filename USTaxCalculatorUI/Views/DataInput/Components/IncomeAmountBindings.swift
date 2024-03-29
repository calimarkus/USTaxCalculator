//
// IncomeAmountBindings.swift
//

import SwiftUI
import TaxModels

extension IncomeAmount {
    static func pickerSelectionBinding(_ amount: Binding<IncomeAmount>) -> Binding<IncomeAmount> {
        Binding {
            switch amount.wrappedValue {
                case .fullFederal: return .fullFederal
                case .partial: return .partial(0.0)
            }
        } set: { val in
            amount.wrappedValue = val
        }
    }

    static func partialValueBinding(_ amount: Binding<IncomeAmount>) -> Binding<Double> {
        Binding {
            switch amount.wrappedValue {
                case .fullFederal: return 0.0
                case let .partial(val): return val
            }
        } set: { val in
            amount.wrappedValue = .partial(val)
        }
    }
}
