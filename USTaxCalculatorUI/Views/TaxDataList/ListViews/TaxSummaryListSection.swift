//
// TaxSummaryListSection.swift
//

import SwiftUI
import TaxOutputModels
import TaxFormatter

struct TaxSummaryListSection: View {
    let taxdata: CalculatedTaxData

    var body: some View {
        NonCollapsableSectionTitle(title: "Income", isFirst: true)

        TaxListGroupView {
            CurrencyView(.boldSumConfig(title: "Total Income", amount: taxdata.totalIncome, showSeparator: false))
        }

        NonCollapsableSectionTitle(title: "Federal Taxes")
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.federalData.summary)
        }

        NonCollapsableSectionTitle(title: "State Taxes (\(FormattingHelper.formattedStates(states: taxdata.stateTaxDatas.map(\.state))))")
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.statesSummary)
        }

        NonCollapsableSectionTitle(title: "Total Taxes")
        TaxListGroupView {
            TaxSummaryView(summary: taxdata.totalSummary)
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
        .frame(minWidth: 500)
        .fixedSize()
    }
}
