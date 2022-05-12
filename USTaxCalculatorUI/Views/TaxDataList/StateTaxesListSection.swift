//
//

import SwiftUI

extension StateTax: Identifiable {
    var id: TaxState { return state }
}

struct StateTaxesListSection: View {
    @ObservedObject var collapseState: SectionCollapseState

    let stateTax: StateTax
    let stateCredits: Double

    var body: some View {
        let title = "\(stateTax.state) Taxes (at \(FormattingHelper.formatPercentage(stateTax.incomeRate)))"
        CollapsableSection(title: title, expanded: collapseState.stateBinding(for: stateTax.state)) { expanded in
            if expanded {
                AdditionView(title: "Deductions", amount: -stateTax.deductions)
                CurrencyView(title: "Taxable Income", amount: stateTax.taxableIncome)

                if let localTax = stateTax.localTax {
                    CurrencyView(title: "State Tax",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                                 amount: stateTax.stateOnlyTaxAmount,
                                 infoText: stateTax.stateOnlyTaxExplanation)
                    CurrencyView(title: "Local Tax (\(localTax.city))",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(localTax.bracket)))",
                                 amount: localTax.taxAmount,
                                 infoText: localTax.bracket.taxCalculationExplanation(localTax.taxableIncome))
                }

                if stateCredits > 0.0 {
                    AdditionView(title: "State Credits", amount: -1 * stateCredits)
                }
            }

            if let _ = stateTax.localTax {
                CurrencyView(title: "Total (State & Local)",
                             subtitle: "(~ \(FormattingHelper.formatPercentage((stateTax.taxAmount - stateCredits) / stateTax.taxableIncome)))",
                             amount: stateTax.taxAmount - stateCredits)
            } else {
                let creditInfo = "\(stateCredits > 0.0 ? " - \(FormattingHelper.formatCurrency(stateCredits))" : "")"
                CurrencyView(title: "State Tax",
                             subtitle: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                             amount: stateTax.taxAmount - stateCredits,
                             infoText: stateTax.stateOnlyTaxExplanation + creditInfo)
            }

            AdditionView(title: "Withheld", amount: -stateTax.withholdings)
            CurrencyView(
                title: "To Pay (\(stateTax.state))",
                amount: stateTax.taxAmount - stateTax.withholdings - stateCredits
            )
        }
    }
}

struct StateTaxesListSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            StateTaxesListSection(collapseState: SectionCollapseState(),
                                  stateTax: ExampleData.exampleTaxDataJohnAndSarah_21().stateTaxes[0],
                                  stateCredits: 350.0)
            StateTaxesListSection(collapseState: SectionCollapseState(),
                                  stateTax: ExampleData.exampleTaxDataJohnAndSarah_21().stateTaxes[1],
                                  stateCredits: 350.0)
        }.frame(height: 600.0)
    }
}
