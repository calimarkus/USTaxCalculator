//
//

import SwiftUI

extension FederalTax: Identifiable {
    var id:String { get { return title } }
}

struct FederalTaxesListSection: View {
    let taxdata:USTaxData
    var summary:TaxSummary { get { return taxdata.taxSummaries.federal }}

    var body: some View {
        CollapsableSection(
            title: "Federal Taxes",
            collapsableContent: {
                if summary.credits > 0 {
                    CurrencyView(title:"Federal Credits", amount:-summary.credits)
                }

                ForEach(taxdata.allFederalTaxes) {
                    CurrencyView(title:"\($0.title) Tax",
                                 secondary: "(\(FormattingHelper.formatPercentage($0.bracket.rate)) over \(FormattingHelper.formattedBracketStart($0.bracket)))",
                                 amount:$0.taxAmount)
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
            FederalTaxesListSection(taxdata: TaxDataSet().activeTaxData)
        }
    }
}
