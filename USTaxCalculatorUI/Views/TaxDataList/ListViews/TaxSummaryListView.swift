//
//

import SwiftUI

struct TaxSummaryView: View {
    var title: String = ""
    let summary: TaxSummary
    var expanded: Bool = true

    var body: some View {
        SumView(title: title.count > 0 ? "Total (\(title))" : "Total",
                amount: summary.taxes)

        if expanded {
            if summary.credits > 0 {
                AdditionView(title: "Credits", amount: -summary.credits)
            }
            AdditionView(title: "Withheld", amount: -summary.withholdings)
        }

        SumView(
            title: title.count > 0 ? "To Pay (\(title))" : "To Pay",
            subtitle: "(~ \(FormattingHelper.formatPercentage(summary.effectiveTaxRate)))",
            amount: summary.outstandingPayment)
    }
}

struct TaxSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TaxListGroupView {
            TaxSummaryView(title: "blah", summary: ExampleData.exampleTaxDataJohnAndSarah_21().taxSummaries.federal)
        }.padding()
    }
}
