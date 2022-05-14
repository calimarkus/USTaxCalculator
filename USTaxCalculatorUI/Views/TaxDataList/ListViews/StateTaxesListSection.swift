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
    let summary: TaxSummary?
    let stateCredits: Double

    var body: some View {
        let title = "\(stateTax.state) Taxes"
        CollapsableSection(title: title, expandedBinding: collapseState.stateBinding(for: stateTax.state)) { expanded in
            if expanded {
                TaxListGroupView {
                    CurrencyView(title: "Total Income", amount: totalIncome)
                    if stateTax.additionalStateIncome > 0.0 {
                        AdditionView(title: "Additional State Income",
                                     amount: stateTax.additionalStateIncome)
                    }
                    AdditionView(title: "State Deductions", amount: -stateTax.deductions)
                    SumView(title: "Taxable Income", amount: stateTax.taxableIncome)
                }

                TaxListGroupView {
                    if stateTax.incomeRate < 1.0 {
                        CurrencyView(title: "State Attributed Income", amount: stateTax.stateAttributedIncome)

                        let info = "\(FormattingHelper.formatCurrency(stateTax.stateAttributedIncome)) / \(FormattingHelper.formatCurrency(totalIncome))"
                        LabeledExplainableValueView(titleText: "State Income Rate",
                                                    valueText: "\(FormattingHelper.formatPercentage(stateTax.incomeRate))",
                                                    infoText: info)
                    }

                    CurrencyView(title: "State Tax",
                                 subtitle: "(\(FormattingHelper.formattedBracketInfo(stateTax.bracket)))",
                                 amount: stateTax.stateOnlyTaxAmount,
                                 infoText: stateTax.stateOnlyTaxExplanation)
                    if let localTax = stateTax.localTax {
                        CurrencyView(title: "Local Tax (\(localTax.city))",
                                     subtitle: "(\(FormattingHelper.formattedBracketInfo(localTax.bracket)))",
                                     amount: localTax.taxAmount,
                                     infoText: localTax.bracket.taxCalculationExplanation(localTax.taxableIncome))
                        SumView(title: "Total",
                                subtitle: "(~ \(FormattingHelper.formatPercentage(stateTax.taxAmount / stateTax.taxableIncome)))",
                                amount: stateTax.taxAmount)
                    }
                }
            }

            if let sum = summary {
                TaxListGroupView {
                    TaxSummaryView(summary: sum, expanded: expanded)
                }
            }
        }
    }
}

struct StateTaxesListSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            let exampleData = ExampleData.exampleTaxDataJohnAndSarah_21()
            StateTaxesListSection(collapseState: SectionCollapseState(),
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[0],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxes[0].state],
                                  stateCredits: exampleData.stateCredits[exampleData.stateTaxes[0].state] ?? 0.0)
            StateTaxesListSection(collapseState: SectionCollapseState(),
                                  totalIncome: exampleData.income.totalIncome,
                                  stateTax: exampleData.stateTaxes[1],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxes[1].state],
                                  stateCredits: exampleData.stateCredits[exampleData.stateTaxes[1].state] ?? 0.0)
        }
        .frame(height: 640.0)
        .padding()
    }
}
