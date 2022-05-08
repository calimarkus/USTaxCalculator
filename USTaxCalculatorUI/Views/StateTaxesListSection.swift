//
//

import SwiftUI

extension StateTax: Identifiable {
    var id: TaxState { return state }
}

struct StateTaxesListSection: View {
    let stateTax: StateTax
    let stateCredits: Double

    var body: some View {
        CollapsableSection(
            title: "\(stateTax.state) Taxes (at \(FormattingHelper.formatPercentage(stateTax.incomeRate)))",
            collapsableContent: {
                AdditionView(title: "Deductions", amount: -stateTax.deductions)
                CurrencyView(title: "Taxable Income", amount: stateTax.taxableIncome)

                if stateCredits > 0.0 {
                    AdditionView(title: "State Credits", amount: -1 * stateCredits)
                }

                if let localTax = stateTax.localTax {
                    CurrencyView(title: "State Tax",
                                 secondary: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                                 amount: stateTax.stateOnlyTaxAmount)
                    CurrencyView(title: "Local Tax (\(localTax.city))",
                                 secondary: "(\(FormattingHelper.formattedBracketInfo(localTax.bracket)))",
                                 amount: localTax.taxAmount)
                }
            },
            fixedContent: {
                if let _ = stateTax.localTax {
                    CurrencyView(title: "Total (State & Local)",
                                 secondary: "(~ \(FormattingHelper.formatPercentage((stateTax.taxAmount - stateCredits) / stateTax.taxableIncome)))",
                                 amount: stateTax.taxAmount - stateCredits)
                } else {
                    CurrencyView(title: "State Tax",
                                 secondary: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                                 amount: stateTax.taxAmount - stateCredits)
                }
                AdditionView(title: "Withheld", amount: -stateTax.withholdings)
                CurrencyView(
                    title: "To Pay (\(stateTax.state))",
                    amount: stateTax.taxAmount - stateTax.withholdings - stateCredits
                )
            }
        )
    }
}

struct StateTaxesListSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            StateTaxesListSection(stateTax: ExampleData.exampleTaxDataJohnAndSarah_21().stateTaxes.first!,
                                  stateCredits: 350.0)
        }
    }
}
