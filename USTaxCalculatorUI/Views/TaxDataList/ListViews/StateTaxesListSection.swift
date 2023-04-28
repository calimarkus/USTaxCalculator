//
// StateTaxesListSection.swift
//

import SwiftUI

extension StateTax: Identifiable {
    var id: String { title }
}

struct StateTaxesListSection: View {
    @Binding var isExpanded: Bool

    let isFirst: Bool
    let totalIncome: Double
    let stateTaxData: StateTaxData
    let summary: TaxSummary?

    var body: some View {
        let stateTax = stateTaxData.tax
        let title = "\(stateTaxData.state) Taxes"
        CollapsableSectionTitle(title: title, isFirst: isFirst, isExpanded: $isExpanded)

        if isExpanded {
            TaxListGroupView {
                CurrencyView(CurrencyViewConfig(title: "Total Income", amount: totalIncome, showSeparator: false))
                if stateTaxData.additionalStateIncome > 0.0 {
                    CurrencyView(.secondaryAdditionConfig(
                        title: "Additional State Income",
                        amount: stateTaxData.additionalStateIncome
                    ))
                }
                ExplainableCurrencyView(
                    .secondaryAdditionConfig(title: "State Deduction", amount: -stateTaxData.deduction.amount),
                    explanation: .deductionInfo(stateTaxData.deduction)
                )
                CurrencyView(.boldSumConfig(title: "Taxable Income", amount: stateTax.taxableIncome.amount))
            }

            TaxListGroupView {
                let hasIncomeRate = stateTax.stateAttributedIncome.rate < 1.0
                if hasIncomeRate {
                    CurrencyView(CurrencyViewConfig(
                        title: "State Attributed Income",
                        amount: stateTax.stateAttributedIncome.amount,
                        showSeparator: false
                    ))

                    LabeledExplainableValueView(titleText: "State Income Rate",
                                                valueText: FormattingHelper.formatPercentage(stateTax.stateAttributedIncome.rate),
                                                infoContent: CalculationExplanationView(stateTax.stateAttributedIncome))
                }

                ExplainableCurrencyView(
                    CurrencyViewConfig(
                        title: "\(stateTax.title) Tax",
                        subtitle: "(\(stateTax.activeBracket.formattedString))",
                        amount: stateTax.taxAmount,
                        showSeparator: hasIncomeRate
                    ), explanation: .taxInfo(stateTax)
                )

                if let localTax = stateTax.localTax {
                    ExplainableCurrencyView(
                        CurrencyViewConfig(
                            title: "\(localTax.title) Tax",
                            subtitle: "(\(localTax.activeBracket.formattedString))",
                            amount: localTax.taxAmount
                        ),
                        explanation: .taxInfo(localTax)
                    )
                }

                if stateTaxData.credits > 0.0 {
                    CurrencyView(CurrencyViewConfig(title: "Tax Credits", amount: -stateTaxData.credits, showPlusMinus: true))
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
    @State static var isExpanded2: Bool = true
    static var previews: some View {
        VStack(alignment: .leading) {
            let exampleData = ExampleData.exampleTaxDataJohnAndSarah_21()
            StateTaxesListSection(isExpanded: $isExpanded1,
                                  isFirst: true,
                                  totalIncome: exampleData.totalIncome,
                                  stateTaxData: exampleData.stateTaxDatas[0],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxDatas[0].state])
            StateTaxesListSection(isExpanded: $isExpanded2,
                                  isFirst: false,
                                  totalIncome: exampleData.totalIncome,
                                  stateTaxData: exampleData.stateTaxDatas[1],
                                  summary: exampleData.taxSummaries.states[exampleData.stateTaxDatas[1].state])
        }
        .padding()
    }
}
