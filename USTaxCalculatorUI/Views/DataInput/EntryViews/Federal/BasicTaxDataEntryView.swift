//
//

import SwiftUI

struct BasicTaxDataEntryView: View {
    @Binding var input: TaxDataInput

    var body: some View {
        Section {
            TextField("Name", text: $input.title)

            Picker("Tax Year", selection: $input.taxYear) {
                Text("2021").tag(TaxYear.y2021)
                Text("2020").tag(TaxYear.y2020)
            }.frame(maxWidth: 180)

            Picker("Filing Type", selection: $input.filingType) {
                Text("Single").tag(FilingType.single)
                Text("Married Jointly").tag(FilingType.marriedJointly)
            }.pickerStyle(.inline)
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
