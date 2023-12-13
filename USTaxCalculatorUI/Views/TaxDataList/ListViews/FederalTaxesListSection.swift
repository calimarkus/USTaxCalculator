//
// FederalTaxesListSection.swift
//

import SwiftUI
import TaxOutputModels
import TaxFormatter

extension BasicTax: Identifiable {
    public var id: String { title }
}

struct FederalTaxesListSection: View {
    @Binding var isExpanded: Bool

    let taxdata: FederalTaxData

    var body: some View {
        CollapsableSectionTitle(title: "Federal Taxes", isExpanded: $isExpanded)

        if isExpanded {
            TaxListGroupView {
                ForEach(taxdata.taxes.indices, id: \.self) { idx in
                    let tax = taxdata.taxes[idx]
                    ExplainableCurrencyView(
                        CurrencyViewConfig(
                            title: "\(tax.title) Tax",
                            subtitle: "(\(tax.activeBracket.formattedString))",
                            amount: tax.taxAmount,
                            showSeparator: idx > 0
                        ),
                        explanation: .taxInfo(tax)
                    )
                }

                if taxdata.credits > 0.0 {
                    CurrencyView(CurrencyViewConfig(title: "Tax Credits", amount: -taxdata.credits, showPlusMinus: true))
                }
            }
        }

        TaxListGroupView {
            TaxSummaryView(summary: taxdata.summary)
        }
    }
}

struct FederalTaxesListSection_Previews: PreviewProvider {
    @State static var isExpanded1: Bool = true
    @State static var isExpanded2: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            FederalTaxesListSection(isExpanded: $isExpanded1,
                                    taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federalData)
            FederalTaxesListSection(isExpanded: $isExpanded2,
                                    taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federalData)
        }.padding()
    }
}
