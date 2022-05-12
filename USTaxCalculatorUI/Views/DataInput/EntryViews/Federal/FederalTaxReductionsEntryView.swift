//
//

import SwiftUI

struct FederalTaxReductionsEntryView: View {
    @Binding var input: TaxDataInput

    var body: some View {
        #if os(macOS)
        Spacer().frame(height: 20.0)
        #endif

        Section(header: Text("Tax Reductions").fontWeight(.bold)) {
            DeductionsPickerView(deductions: $input.federalDeductions)
            CurrencyValueInputView(caption: "Tax Credits",
                                   amount: $input.federalCredits)
            CurrencyValueInputView(caption: "Additional Withholdings",
                                   subtitle: "E.g. estimated payments",
                                   amount: $input.additionalFederalWithholding)
        }
    }
}

struct FederalTaxReductionsEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()

    static var previews: some View {
        Form {
            FederalTaxReductionsEntryView(input: $input)
        }
        #if os(macOS)
        .padding()
        #endif
    }
}
