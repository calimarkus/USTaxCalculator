//
//

import SwiftUI

extension StateTax: Identifiable {
    var id: TaxState { return state }
}

struct StateTaxesListSection: View {
    @Binding var isExpanded: Bool

    let isFirst: Bool
    let totalIncome: Double
    let stateTax: StateTax
    let summary: TaxSummary?

    var body: some View {
        let title = "\(stateTax.state) Taxes"
        CollapsableSectionTitle(title: title, isFirst: isFirst, isExpanded: $isExpanded)

        if isExpanded {
            TaxListGroupView {
                CurrencyView(CurrencyViewConfig(title: "Total Income", amount: totalIncome, showSeparator: false))
                if stateTax.additionalStateIncome > 0.0 {
                    AdditionView(title: "Additional State Income",
                                 amount: stateTax.additionalStateIncome)
                }
                AdditionView(title: "State Deductions", amount: -stateTax.deductions)
                SumView(title: "Taxable Income", amount: stateTax.taxableIncome.amount)
            }

            TaxListGroupView {
                let hasIncomeRate = stateTax.incomeRate < 1.0
                if hasIncomeRate {
                    CurrencyView(CurrencyViewConfig(
                        title: "State Attributed Income",
                        amount: stateTax.stateAttributedIncome,
                        showSeparator: false))

                    let incomeRateText = FormattingHelper.formatPercentage(stateTax.incomeRate)
                    let info = "\(FormattingHelper.formatCurrency(stateTax.stateAttributedIncome)) / \(FormattingHelper.formatCurrency(totalIncome)) = \(incomeRateText)"
                    LabeledExplainableValueView(titleText: "State Income Rate",
                                                valueText: incomeRateText,
                                                infoText: info)
                }

                ExplainableCurrencyView(
                    CurrencyViewConfig(
                        title: "State Tax",
                        subtitle: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                        amount: stateTax.stateOnlyTaxAmount,
                        showSeparator: hasIncomeRate),
                    explanation:
                    .bracket(bracketGroup: stateTax.bracketGroup,
                             activeBracket: stateTax.bracket,
                             taxableIncome: stateTax.taxableIncome))

                if let localTax = stateTax.localTax {
                    ExplainableCurrencyView(
                        CurrencyViewConfig(
                            title: "Local Tax (\(localTax.city))",
                            subtitle: "(\(FormattingHelper.formattedBracketInfo(localTax.bracket)))",
                            amount: localTax.taxAmount),
                        explanation:
                                .bracket(bracketGroup: localTax.bracketGroup,
                                         activeBracket: localTax.bracket,
                                         taxableIncome: localTax.taxableIncome))
                }

                if stateTax.credits > 0.0 {
                    CurrencyView(CurrencyViewConfig(title: "Tax Credits", amount: -stateTax.credits, showPlusMinus: true))
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
                                  isFirst: true,
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[0],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxes[0].state])
            StateTaxesListSection(isExpanded: $isExpanded2,
                                  isFirst: false,
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[1],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxes[1].state])
        }
        .frame(height: 540.0)
        .padding()
    }
}
