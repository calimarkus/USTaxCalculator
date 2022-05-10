//
//

import SwiftUI

struct BasicTaxDataEntryView: View {
    @Binding var input: TaxDataInput

    var body: some View {
        Section {
            TextField("Name", text: $input.title)

            Picker("Filing Type", selection: $input.filingType) {
                Text("Single").tag(FilingType.single)
                Text("Married Jointly").tag(FilingType.marriedJointly)
            }.pickerStyle(.inline)

            Picker("Tax Year", selection: $input.taxYear) {
                Text("2021").tag(TaxYear.y2021)
                Text("2020").tag(TaxYear.y2020)
            }

            Picker("Deductions", selection: deductionPickerBinding()) {
                Text("Standard deduction + additional amount:").tag(DeductionAmount.standard(additionalDeductions: 0.0))
                Text("Custom amount:").tag(DeductionAmount.custom(0.0))
            }.pickerStyle(.inline)

            if case .standard = input.federalDeductions {
                CurrencyValueInputView(caption: "",
                                       amount: deductionValueBinding(customDeduction: false))
            } else {
                CurrencyValueInputView(caption: "",
                                       amount: deductionValueBinding(customDeduction: true))
            }

            CurrencyValueInputView(caption: "Additional Withholdings",
                                   subtitle: "E.g. estimated payments",
                                   amount: $input.additionalFederalWithholding)
            CurrencyValueInputView(caption: "Tax credits",
                                   amount: $input.federalCredits)
        }
    }

    func deductionPickerBinding() -> Binding<DeductionAmount> {
        return Binding {
            switch self.input.federalDeductions {
                case .standard: return .standard(additionalDeductions: 0.0)
                case .custom: return .custom(0.0)
            }
        } set: { val in
            self.input.federalDeductions = val
        }
    }

    func deductionValueBinding(customDeduction: Bool) -> Binding<Double> {
        return Binding {
            switch self.input.federalDeductions {
                case let .standard(val): return val
                case let .custom(val): return val
            }
        } set: { val in
            self.input.federalDeductions = customDeduction ? .custom(val) : .standard(additionalDeductions: val)
        }
    }
}

struct BasicTaxDataEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()
    static var previews: some View {
        Form {
            BasicTaxDataEntryView(input: $input)
        }
        .padding()
    }
}
