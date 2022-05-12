//
//

import SwiftUI

struct FederalTaxReductionsEntryView: View {
    @Binding var input: TaxDataInput

    var body: some View {
        Spacer().frame(height: 20.0)
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
        }.padding()
    }
}