//
//

import SwiftUI

extension FederalTax: Identifiable {
    var id: String { return title }
}

struct FederalTaxesListSection: View {
    let taxdata: USTaxData
    var summary: TaxSummary { return taxdata.taxSummaries.federal }

    var body: some View {
        CollapsableSection(
            title: "Federal Taxes",
            collapsableContent: {
                ForEach(taxdata.allFederalTaxes) {
                    CurrencyView(title: "\($0.title) Tax",
                                 secondary: "(\(FormattingHelper.formattedBracketInfo($0.bracket)))",
                                 amount: $0.taxAmount)
                }
                
                if summary.credits > 0 {
                    AdditionView(title: "Federal Credits", amount: -summary.credits)
                }
            },
            fixedContent: {
                TaxSummaryView(title: "Fed", summary: summary)
            }
        )
    }
}

struct FederalTaxesListSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FederalTaxesListSection(taxdata: ExampleData.single21Data())
        }
    }
}
