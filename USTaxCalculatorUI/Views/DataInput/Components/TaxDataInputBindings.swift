//
//

import SwiftUI

extension TaxDataInput
{
    static func stateDeductionsBinding(_ stateDeductions: Binding<[TaxState: DeductionAmount]>,
                                       for state: TaxState) -> Binding<DeductionAmount>
    {
        return Binding(get: {
            stateDeductions.wrappedValue[state, default: DeductionAmount.standard(additionalDeductions: 0.0)]
        }, set: {
            stateDeductions.wrappedValue[state] = $0
        })
    }

    static func stateCreditsBinding(_ stateCredits: Binding<[TaxState: Double]>,
                                    for state: TaxState) -> Binding<Double>
    {
        return Binding(get: {
            stateCredits.wrappedValue[state, default: 0.0]
        }, set: {
            stateCredits.wrappedValue[state] = $0
        })
    }
}
