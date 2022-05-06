//
//

import SwiftUI

extension StateTax: Identifiable {
    var id:TaxState { get { return state } }
}

struct StateTaxesListSection: View {
    let taxdata:USTaxData
    var summary:TaxSummary { get { return taxdata.taxSummaries.states }}

    func creditsForState(_ state:TaxState) -> Double {
        return taxdata.stateCredits[state] ?? 0.0
    }

    var body: some View {
        CollapsableSection(
            title: "State Taxes",
            collapsableContent: {
                ForEach(taxdata.stateTaxes) { stateTax in
                    CurrencyView(title:"\(stateTax.state)",
                                 secondary: "(at \(FormattingHelper.formatPercentage(stateTax.incomeRate)))")

                    CurrencyView(title: "  Deductions", amount:-stateTax.deductions)
                    CurrencyView(title: "  Taxable Income", amount:stateTax.taxableIncome)

                    if creditsForState(stateTax.state) > 0.0 {
                        CurrencyView(title:"  State Credits",
                                     amount:-1 * creditsForState(stateTax.state))
                    }

                    CurrencyView(title:"  State Tax",
                                 secondary: "(\(FormattingHelper.formatPercentage(stateTax.bracket.rate)) over \(FormattingHelper.formattedBracketStart(stateTax.bracket)))",
                                 amount:stateTax.stateOnlyTaxAmount)

                    if let localTax = stateTax.localTax {
                        CurrencyView(title:"  Local Tax (\(localTax.city))",
                                     secondary: "(\(FormattingHelper.formatPercentage(localTax.bracket.rate)) over \(FormattingHelper.formattedBracketStart(localTax.bracket)))",
                                     amount: localTax.taxAmount)
                        CurrencyView(title: "  Total",
                                     amount: stateTax.taxAmount - creditsForState(stateTax.state))
                    }

                    CurrencyView(title:"  Withheld", amount:-stateTax.withholdings)
                    CurrencyView(
                        title: "  To Pay (\(stateTax.state))",
                        amount: stateTax.taxAmount - stateTax.withholdings - creditsForState(stateTax.state))
                }
            },
            fixedContent: {
                TaxSummaryView(title: "State & Local", summary: summary)
            }
        )
    }
}

struct StateTaxesListSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            StateTaxesListSection(taxdata: TaxDataSet().activeTaxData)
        }.frame(height:600)
    }
}
