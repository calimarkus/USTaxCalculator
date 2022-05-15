//
//

import SwiftUI

extension StateTax: Identifiable {
    var id: TaxState { return state }
}

struct StateTaxesListSection: View {
    @Binding var isExpanded: Bool

    let totalIncome: Double
    let stateTax: StateTax
    let summary: TaxSummary?

    var body: some View {
        let title = "\(stateTax.state) Taxes"
        CollapsableSectionTitle(title: title, isExpanded: $isExpanded)

        if isExpanded {
            TaxListGroupView {
                CurrencyView(title: "Total Income", amount: totalIncome, showSeparator: false)
                if stateTax.additionalStateIncome > 0.0 {
                    AdditionView(title: "Additional State Income",
                                 amount: stateTax.additionalStateIncome)
                }
                AdditionView(title: "State Deductions", amount: -stateTax.deductions)
                SumView(title: "Taxable Income", amount: stateTax.taxableIncome)
            }

            TaxListGroupView {
                let hasIncomeRate = stateTax.incomeRate < 1.0
                if hasIncomeRate {
                    CurrencyView(title: "State Attributed Income",
                                 amount: stateTax.stateAttributedIncome,
                                 showSeparator: false)

                    let info = "\(FormattingHelper.formatCurrency(stateTax.stateAttributedIncome)) / \(FormattingHelper.formatCurrency(totalIncome))"
                    LabeledExplainableValueView(titleText: "State Income Rate",
                                                valueText: "\(FormattingHelper.formatPercentage(stateTax.incomeRate))",
                                                infoText: info)
                }

                CurrencyView(title: "State Tax",
                             subtitle: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                             amount: stateTax.stateOnlyTaxAmount,
                             infoText: stateTax.stateOnlyTaxExplanation,
                             showSeparator: hasIncomeRate)
                if let localTax = stateTax.localTax {
                    CurrencyView(title: "Local Tax (\(localTax.city))",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(localTax.bracket)))",
                                 amount: localTax.taxAmount,
                                 infoText: localTax.bracket.taxCalculationExplanation(localTax.taxableIncome))
                    SumView(title: "Total",
                            subtitle: "(~ \(FormattingHelper.formatPercentage(stateTax.taxAmount / stateTax.taxableIncome)) effective)",
                            amount: stateTax.taxAmount)
                }
            }
        }

        if let sum = summary {
            TaxListGroupView {
                TaxSummaryView(summary: sum, expanded: isExpanded)
            }
        }
    }
}

struct StateTaxesListSection_Previews: PreviewProvider {
    @State static var isExpanded1: Bool = true
    @State static var isExpanded2: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            let exampleData = ExampleData.exampleTaxDataJohnAndSarah_21()
            StateTaxesListSection(isExpanded: $isExpanded1,
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[0],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxes[0].state])
            StateTaxesListSection(isExpanded: $isExpanded2,
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[1],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxes[1].state])
        }
        .frame(height: 540.0)
        .padding()
    }
}
