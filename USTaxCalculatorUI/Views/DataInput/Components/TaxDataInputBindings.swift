//
// TaxDataInputBindings.swift
//

import SwiftUI
import TaxInputModels
import TaxPrimitives

public extension TaxDataInput {
    static func stateDeductionsBinding(_ stateDeductions: Binding<[TaxState: DeductionInput]>,
                                       for state: TaxState) -> Binding<DeductionInput>
    {
        Binding(get: {
            stateDeductions.wrappedValue[state, default: DeductionInput.standard(additionalDeductions: 0.0)]
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
