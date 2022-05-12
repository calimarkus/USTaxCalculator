//
//

import SwiftUI

extension StateTax: Identifiable {
    var id: TaxState { return state }
}

struct StateTaxesListSection: View {
    @ObservedObject var collapseState: SectionCollapseState

    let totalIncome: Double
    let stateTax: StateTax
    let stateCredits: Double

    var body: some View {
        let title = "\(stateTax.state) Taxes"
        CollapsableSection(title: title, expanded: collapseState.stateBinding(for: stateTax.state)) { expanded in
            if expanded {
                CurrencyView(title: "Total Income", amount: totalIncome)
                if stateTax.additionalStateIncome > 0.0 {
                    AdditionView(title: "Additional State Income",
                                 amount: stateTax.additionalStateIncome)
                }
                AdditionView(title: "State Deductions", amount: -stateTax.deductions)
                SumView(title: "Taxable Income", amount: stateTax.taxableIncome)

                if stateTax.incomeRate < 1.0 {
                    CurrencyView(title: "State Attributed Income",
                                 amount: stateTax.stateAttributedIncome)

                    let info = "\(FormattingHelper.formatCurrency(stateTax.stateAttributedIncome)) / \(FormattingHelper.formatCurrency(totalIncome))"
                    LabeledExplainableValueView(titleText: "State Income Rate",
                                                valueText: "\(FormattingHelper.formatPercentage(stateTax.incomeRate))",
                                                infoText: info)
                }

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
                SumView(title: "Total (State & Local)",
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
            let exampleData = ExampleData.exampleTaxDataJohnAndSarah_21()
            StateTaxesListSection(collapseState: SectionCollapseState(),
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[0],
                                  stateCredits: exampleData.stateCredits[exampleData.stateTaxes[0].state] ?? 0.0)
            StateTaxesListSection(collapseState: SectionCollapseState(),
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[1],
                                  stateCredits: exampleData.stateCredits[exampleData.stateTaxes[1].state] ?? 0.0)
        }.frame(height: 600.0)
    }
}
