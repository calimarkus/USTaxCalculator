//
//

import SwiftUI

struct TaxSummaryListSection: View {
    @ObservedObject var collapseState: SectionCollapseState

    let taxdata: CalculatedTaxData

    var body: some View {
        CollapsableSection(title: "Total", expandedBinding: $collapseState.summary) { expanded in
            if taxdata.stateTaxes.count > 1 {
                TaxListGroupView {
                    TaxSummaryView(title: FormattingHelper.formattedStates(states: taxdata.stateTaxes.map { $0.state }),
                                   summary: taxdata.taxSummaries.stateTotal,
                                   expanded: expanded)
                }
            }
            TaxListGroupView {
                TaxSummaryView(summary: taxdata.taxSummaries.total, expanded: expanded)
            }
        }
    }
}

struct TaxSummaryListSection_Previews: PreviewProvider {
    static var previews: some View {
        TaxSummaryListSection(
            collapseState: SectionCollapseState(),
            taxdata: ExampleData.exampleTaxDataJohnAndSarah_21()
        ).padding()
    }
}
