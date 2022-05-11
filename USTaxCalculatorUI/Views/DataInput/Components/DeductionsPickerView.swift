//
//

import SwiftUI

struct DeductionsPickerView: View {
    @Binding var deductions: DeductionAmount

    var body: some View {
        Picker("Deductions", selection: DeductionAmount.pickerSelectionBinding($deductions)) {
            Text("Standard deduction + additional amount:").tag(DeductionAmount.standard(additionalDeductions: 0.0))
            Text("Custom amount:").tag(DeductionAmount.custom(0.0))
        }.pickerStyle(.inline)

        if case .standard = deductions {
            CurrencyValueInputView(caption: "",
                                   amount: DeductionAmount.valueBinding($deductions,
                                                                        isCustomDeduction: false))
        } else {
            CurrencyValueInputView(caption: "",
                                   amount: DeductionAmount.valueBinding($deductions,
                                                                        isCustomDeduction: true))
        }
    }
}

struct DeductionsPickerView_Previews: PreviewProvider {
    @State static var deductions: DeductionAmount = .standard(additionalDeductions: 300)

    static var previews: some View {
        Form {
            DeductionsPickerView(deductions: $deductions)
        }.padding()
    }
}
