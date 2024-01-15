//
// BasicTaxDataEntryView.swift
//

import SwiftUI
import TaxCalculator
import TaxModels

struct BasicTaxDataEntryView: View {
    @Binding var input: TaxDataInput

    var body: some View {
        Section {
            TextField("Name", text: $input.title)

            Picker("Tax Year", selection: $input.taxYear) {
                Text("2023").tag(TaxYear.y2023)
                Text("2022").tag(TaxYear.y2022)
                Text("2021").tag(TaxYear.y2021)
                Text("2020").tag(TaxYear.y2020)
            }
            #if os(macOS)
            .frame(maxWidth: 180)
            #endif

            Picker("Filing Type", selection: $input.filingType) {
                Text("Single").tag(FilingType.single)
                Text("Married Jointly").tag(FilingType.marriedJointly)
            }.macOnlyInlinePickerStyle()
        }
    }
}

struct BasicTaxDataEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()
    static var previews: some View {
        Form {
            BasicTaxDataEntryView(input: $input)
        }.macOnlyPadding(30.0)
    }
}
