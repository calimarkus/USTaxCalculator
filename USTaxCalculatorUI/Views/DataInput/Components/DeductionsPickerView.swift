//
// DeductionsPickerView.swift
//

import SwiftUI
import TaxModels

struct DeductionsPickerView: View {
    @Binding var deductions: DeductionKind

    var body: some View {
        Picker("Deductions", selection: DeductionKind.pickerSelectionBinding($deductions)) {
            Text("Standard deduction").tag(DeductionKind.standard(additionalDeductions: 0.0))
            Text("Custom amount:").tag(DeductionKind.custom(0.0))
        }.macOnlyInlinePickerStyle()

        if case .standard = deductions {
            CurrencyValueInputView(caption: "Additional amount:",
                                   amount: DeductionKind.valueBinding($deductions,
                                                                      isCustomDeduction: false))
        } else {
            CurrencyValueInputView(amount: DeductionKind.valueBinding($deductions,
                                                                      isCustomDeduction: true))
        }
    }
}

struct DeductionsPickerView_Previews: PreviewProvider {
    @State static var deductions: DeductionKind = .standard(additionalDeductions: 300)

    static var previews: some View {
        Form {
            DeductionsPickerView(deductions: $deductions)
        }.padding()
    }
}
