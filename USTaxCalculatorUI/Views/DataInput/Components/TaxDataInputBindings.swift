//
// TaxDataInputBindings.swift
//

import SwiftUI
import TaxOutputModels
import TaxPrimitives

public extension TaxDataInput {
    static func stateDeductionsBinding(_ stateDeductions: Binding<[TaxState: DeductionKind]>,
                                       for state: TaxState) -> Binding<DeductionKind>
    {
        Binding(get: {
            stateDeductions.wrappedValue[state, default: .standard(additionalDeductions: 0.0)]
        }, set: {
            stateDeductions.wrappedValue[state] = $0
        })
    }

    static func stateCreditsBinding(_ stateCredits: Binding<[TaxState: Double]>,
                                    for state: TaxState) -> Binding<Double>
    {
        Binding(get: {
            stateCredits.wrappedValue[state, default: 0.0]
        }, set: {
            stateCredits.wrappedValue[state] = $0
        })
    }
}
