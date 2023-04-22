//
// TaxSummaryView.swift
//

import SwiftUI

struct TaxSummaryView: View {
    var title: String = ""
    let summary: TaxSummary
    var expanded: Bool = true

    var body: some View {
        CurrencyView(.boldSumConfig(
            title: title.count > 0 ? "Total (\(title))" : "Total",
            subtitle: "(~ \(FormattingHelper.formatPercentage(summary.effectiveTaxRate)) effective)",
            amount: summary.taxes,
            showSeparator: false
        ))

        if expanded {
            CurrencyView(.secondaryAdditionConfig(title: "Withheld", amount: -summary.withholdings))
        }

        let paymentTitle = summary.outstandingPayment < 0 ? "Tax Refund" : "To Pay"
        CurrencyView(.boldSumConfig(
            title: title.count > 0 ? "\(paymentTitle) (\(title))" : paymentTitle,
            amount: summary.outstandingPayment
        ))
    }
}

struct TaxSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            TaxListGroupView {
                TaxSummaryView(title: "blah", summary: ExampleData.exampleTaxDataJohnAndSarah_21().taxSummaries.federal)
            }
            TaxListGroupView {
                TaxSummaryView(title: "blah", summary: ExampleData.exampleTaxDataJohnAndSarah_21().taxSummaries.federal, expanded: false)
            }
        }.padding()
    }
}
