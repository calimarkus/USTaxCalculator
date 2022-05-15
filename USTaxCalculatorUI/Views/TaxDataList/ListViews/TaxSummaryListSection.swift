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
    @State static var isExpanded1: Bool = true
    @State static var isExpanded2: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            TaxSummaryListSection(
                isExpanded: $isExpanded1,
                taxdata: ExampleData.exampleTaxDataJohnAndSarah_21()
            )
            TaxSummaryListSection(
                isExpanded: $isExpanded2,
                taxdata: ExampleData.exampleTaxDataJohnAndSarah_21()
            )
        }.padding()
    }
}
