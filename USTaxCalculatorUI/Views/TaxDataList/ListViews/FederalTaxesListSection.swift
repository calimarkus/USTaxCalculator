//
//

import SwiftUI

extension FederalTax: Identifiable {
    var id: String { return title }
}

struct FederalTaxesListSection: View {
    @Binding var isExpanded: Bool

    let taxdata: CalculatedTaxData
    var summary: TaxSummary { return taxdata.taxSummaries.federal }

    var body: some View {
        CollapsableSectionTitle(title: "Federal Taxes", isExpanded: $isExpanded)

        if isExpanded {
            TaxListGroupView {
                ForEach(taxdata.allFederalTaxes) { tax in
                    CurrencyView(title: "\(tax.title) Tax",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(tax.bracket)))",
                                 amount: tax.taxAmount,
                                 infoText: tax.bracket.taxCalculationExplanation(tax.taxableIncome))
                }
            }
        }
        TaxListGroupView {
            TaxSummaryView(summary: summary, expanded: isExpanded)
        }
    }
}

struct FederalTaxesListSection_Previews: PreviewProvider {
    @State static var isExpanded: Bool = true
    static var previews: some View {
        FederalTaxesListSection(isExpanded: $isExpanded,
                                taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .padding()
    }
}
