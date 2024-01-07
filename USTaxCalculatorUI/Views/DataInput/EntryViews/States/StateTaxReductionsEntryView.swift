//
// StateTaxReductionsEntryView.swift
//

import SwiftUI
import TaxCalculator
import TaxModels

struct StateTaxReductionsEntryView: View {
    @Binding var input: TaxDataInput
    @Binding var stateIncome: StateIncome

    var body: some View {
        Section(header: Text("Tax Reductions").fontWeight(.bold)) {
            CurrencyValueInputView(caption: "Withholdings",
                                   subtitle: "(W-2, Box 17)",
                                   amount: $stateIncome.withholdings)

            CurrencyValueInputView(caption: "Tax Credits",
                                   amount: TaxDataInput.stateCreditsBinding($input.stateCredits,
                                                                            for: stateIncome.state))

            DeductionsPickerView(deductions: TaxDataInput.stateDeductionsBinding($input.stateDeductions, for: stateIncome.state))
        }
    }
}

struct StateTaxReductionsEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()
    @State static var stateIncome: StateIncome = .init()

    static var previews: some View {
        Form {
            StateTaxReductionsEntryView(input: $input,
                                        stateIncome: $stateIncome)
        }.macOnlyPadding(30.0)
    }
}
