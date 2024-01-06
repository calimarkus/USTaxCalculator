//
// FederalEntryTab.swift
//

import SwiftUI
import TaxCalculator

struct FederalEntryTab: View {
    @Binding var input: TaxDataInput

    var body: some View {
        #if os(macOS)
            ScrollView {
                HStack {
                    Spacer()
                    form()
                        .frame(maxWidth: 500)
                        .padding()
                    Spacer()
                }
            }
        #else
            form()
        #endif
    }

    @ViewBuilder
    func form() -> some View {
        Form {
            BasicTaxDataEntryView(input: $input)
            FederalTaxDataEntryView(income: $input.income)
            FederalTaxReductionsEntryView(input: $input)
        }
    }
}

struct FederalEntryTab_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init()

    static var previews: some View {
        FederalEntryTab(input: $input)
        #if os(macOS)
            .padding()
            .frame(height: 700.0)
        #endif
    }
}
