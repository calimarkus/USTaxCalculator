//
//

import SwiftUI

extension FederalTax: Identifiable {
    var id: String { return title }
}

struct FederalTaxesListSection: View {
    @ObservedObject var collapseState: SectionCollapseState

    let taxdata: CalculatedTaxData
    var summary: TaxSummary { return taxdata.taxSummaries.federal }

    var body: some View {
        CollapsableSection(title: "Federal Taxes", expanded: $collapseState.federal) { expanded in
            if expanded {
                ForEach(taxdata.allFederalTaxes) { tax in
                    CurrencyView(title: "\(tax.title) Tax",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(tax.bracket)))",
                                 amount: tax.taxAmount,
                                 infoText: tax.bracket.taxCalculationExplanation(tax.taxableIncome))
                }

                if summary.credits > 0 {
                    AdditionView(title: "Federal Credits", amount: -summary.credits)
                }
            }
            TaxSummaryView(title: "Fed", summary: summary)
        }
    }
}

struct FederalTaxesListSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FederalTaxesListSection(collapseState: SectionCollapseState(),
                                    taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
        }
    }
}
