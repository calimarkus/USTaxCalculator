//
//

import SwiftUI

struct TaxSummaryView: View {
    var title: String = ""
    let summary: TaxSummary

    var body: some View {
        SumView(title: title.count > 0 ? "Total Taxes (\(title))" : "Total Taxes",
                amount: summary.taxes)
        AdditionView(title: "Withheld", amount: -summary.withholdings)
        SumView(
            title: title.count > 0 ? "To Pay (\(title))" : "To Pay",
            secondary: "(~ \(FormattingHelper.formatPercentage(summary.effectiveTaxRate)))",
            amount: summary.outstandingPayment)
    }
}

struct TaxSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TaxSummaryView(title: "blah", summary: ExampleData.single21Data().taxSummaries.federal)
        }
    }
}
