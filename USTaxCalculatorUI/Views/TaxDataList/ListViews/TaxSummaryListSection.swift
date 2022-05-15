//
//

import SwiftUI

struct TaxSummaryListSection: View {
    @Binding var isExpanded: Bool

    let taxdata: CalculatedTaxData

    var body: some View {
        CollapsableSectionTitle(title: "Total", isExpanded: $isExpanded)

        if taxdata.stateTaxes.count > 1 {
            TaxListGroupView {
                TaxSummaryView(title: FormattingHelper.formattedStates(states: taxdata.stateTaxes.map { $0.state }),
                               summary: taxdata.taxSummaries.stateTotal,
                               expanded: isExpanded)
            }
        }
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.taxSummaries.total, expanded: isExpanded)
        }
    }
}

struct TaxSummaryListSection_Previews: PreviewProvider {
    @State static var isExpanded: Bool = true
    static var previews: some View {
        TaxSummaryListSection(
            isExpanded: $isExpanded,
            taxdata: ExampleData.exampleTaxDataJohnAndSarah_21()
        ).padding()
    }
}
