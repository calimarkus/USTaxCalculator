//
// DeductionsPickerView.swift
//

import SwiftUI
import TaxOutputModels

struct DeductionsPickerView: View {
    @Binding var deductions: DeductionInput

    var body: some View {
        Picker("Deductions", selection: DeductionInput.pickerSelectionBinding($deductions)) {
            Text("Standard deduction").tag(DeductionInput.standard(additionalDeductions: 0.0))
            Text("Custom amount:").tag(DeductionInput.custom(0.0))
        }.macOnlyInlinePickerStyle()

        if case .standard = deductions {
            CurrencyValueInputView(caption: "Additional amount:",
                                   amount: DeductionInput.valueBinding($deductions,
                                                                       isCustomDeduction: false))
        } else {
            CurrencyValueInputView(amount: DeductionInput.valueBinding($deductions,
                                                                       isCustomDeduction: true))
        }
    }
}

struct DeductionsPickerView_Previews: PreviewProvider {
    @State static var deductions: DeductionInput = .standard(additionalDeductions: 300)

    static var previews: some View {
        Form {
            DeductionsPickerView(deductions: $deductions)
        }.padding()
    }
}
