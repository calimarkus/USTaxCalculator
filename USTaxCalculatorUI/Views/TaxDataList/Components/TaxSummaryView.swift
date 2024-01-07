//
// TaxSummaryView.swift
//

import SwiftUI
import TaxCalculator
import TaxFormatter
import TaxModels

struct TaxSummaryView: View {
    var title: String = ""
    let summary: TaxSummary

    var body: some View {
        CurrencyView(.boldSumConfig(
            title: title.count > 0 ? "Total (\(title))" : "Total",
            subtitle: "(~ \(FormattingHelper.formatPercentage(summary.effectiveTaxRate)) effective)",
            amount: summary.taxes,
            showSeparator: false
        ))

        CurrencyView(.secondaryAdditionConfig(title: "Withheld", amount: -summary.withholdings))

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
                TaxSummaryView(title: "blah", summary: ExampleData.exampleTaxDataJohnAndSarah_21().federalData.summary)
            }
            TaxListGroupView {
                TaxSummaryView(title: "blah", summary: ExampleData.exampleTaxDataJohnAndSarah_21().federalData.summary)
            }
        }.padding()
    }
}
