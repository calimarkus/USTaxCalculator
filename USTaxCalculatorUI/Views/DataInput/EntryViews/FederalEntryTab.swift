//
//

import SwiftUI

struct FederalEntryTab: View {
    @Binding var input: TaxDataInput

    var body: some View {
        ScrollView {
            Form {
                BasicTaxDataEntryView(input: $input)
                FederalTaxDataEntryView(income: $input.income)
                TaxReductionsEntryView(input: $input)
            }
            .padding()
        }
    }
}

struct FederalEntryTab_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()

    static var previews: some View {
        FederalEntryTab(input: $input)
            .padding()
            .frame(height: 600.0)
    }
}
