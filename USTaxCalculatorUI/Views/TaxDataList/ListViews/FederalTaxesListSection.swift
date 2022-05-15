//
//

import SwiftUI

extension FederalTax: Identifiable {
    var id: String { return title }
}

struct FederalTaxesListSection: View {
    @Binding var isExpanded: Bool

    let taxdata: FederalTaxData
    var summary: TaxSummary

    var body: some View {
        CollapsableSectionTitle(title: "Federal Taxes", isExpanded: $isExpanded)

        if isExpanded {
            TaxListGroupView {
                ForEach(taxdata.taxes.indices, id: \.self) { idx in
                    let tax = taxdata.taxes[idx]
                    CurrencyView(title: "\(tax.title) Tax",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(tax.bracket)))",
                                 amount: tax.taxAmount,
                                 infoText: tax.bracket.taxCalculationExplanation(tax.taxableIncome),
                                 showSeparator: idx > 0)
                }
            }
        }
        TaxListGroupView {
            TaxSummaryView(summary: summary, expanded: isExpanded)
        }
    }
}

struct FederalTaxesListSection_Previews: PreviewProvider {
    @State static var isExpanded1: Bool = true
    @State static var isExpanded2: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            FederalTaxesListSection(isExpanded: $isExpanded1,
                                    taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federal,
                                    summary: ExampleData.exampleTaxDataJohnAndSarah_21().taxSummaries.federal)
            FederalTaxesListSection(isExpanded: $isExpanded2,
                                    taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federal,
                                    summary: ExampleData.exampleTaxDataJohnAndSarah_21().taxSummaries.federal)
        }.padding()
    }
}
