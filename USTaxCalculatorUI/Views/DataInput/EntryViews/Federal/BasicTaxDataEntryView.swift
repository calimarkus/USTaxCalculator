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
            }
            #if os(macOS)
            .frame(maxWidth: 180)
            #endif

            Picker("Filing Type", selection: $input.filingType) {
                Text("Single").tag(FilingType.single)
                Text("Married Jointly").tag(FilingType.marriedJointly)
            }
            #if os(macOS)
            .pickerStyle(.inline)
            #endif
        }
    }
}

struct BasicTaxDataEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()
    static var previews: some View {
        Form {
            BasicTaxDataEntryView(input: $input)
        }
        #if os(macOS)
        .padding()
        #endif
    }
}
