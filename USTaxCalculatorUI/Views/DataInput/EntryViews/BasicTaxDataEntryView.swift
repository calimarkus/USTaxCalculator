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

            Picker("Deductions", selection: $input.federalDeductions) {
                Text("Standard").tag(DeductionAmount.standard(additionalDeductions: 0.0))
                Text("Custom").tag(DeductionAmount.custom(0.0))
            }.pickerStyle(.inline)

            if case .standard = input.federalDeductions {
                CurrencyValueInputView(caption: "Additional deductions",
                                       amount: deductionBinding(customDeduction:false))
            } else {
                CurrencyValueInputView(caption: "Custom deductions",
                                       amount: deductionBinding(customDeduction:true))
            }

            CurrencyValueInputView(caption: "Additional Withholdings",
                                   subtitle: "E.g. estimated payments",
                                   amount: $input.additionalFederalWithholding)
            CurrencyValueInputView(caption: "Tax credits",
                                   amount: $input.federalCredits)
        }
    }

    func deductionBinding(customDeduction:Bool) -> Binding<Double> {
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
