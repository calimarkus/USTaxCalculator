//
//

import SwiftUI

struct TaxSummaryListSection: View {
    let taxdata: CalculatedTaxData

    var body: some View {
        NonCollapsableSectionTitle(title: "Income", isFirst: true)
        TaxListGroupView {
            SumView(title: "Total Income", amount: taxdata.income.totalIncome, showSeparator: false)
        }

        NonCollapsableSectionTitle(title: "Federal Taxes")
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.taxSummaries.federal)
        }

        NonCollapsableSectionTitle(title: "State Taxes (\(FormattingHelper.formattedStates(states: taxdata.stateTaxes.map { $0.state })))")
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.taxSummaries.stateTotal)
        }

        NonCollapsableSectionTitle(title: "Total Taxes")
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.taxSummaries.total)
        }
    }
}

struct TaxSummaryListSection_Previews: PreviewProvider {
    @State static var isExpanded1: Bool = true
    static var previews: some View {
        VStack(alignment: .leading) {
            TaxSummaryListSection(taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
        }
        .padding()
        .frame(height: 460)
    }
}
