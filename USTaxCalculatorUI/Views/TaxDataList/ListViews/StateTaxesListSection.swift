//
// StateTaxesListSection.swift
//

import SwiftUI
import TaxOutputModels

extension AttributableTax: Identifiable {
    public var id: String { title }
}

struct StateTaxesListSection: View {
    @Binding var isExpanded: Bool

    let isFirst: Bool
    let totalIncome: Double
    let stateTaxData: StateTaxData

    var body: some View {
        CollapsableSectionTitle(title: "\(stateTaxData.state) Taxes", isFirst: isFirst, isExpanded: $isExpanded)

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
                CurrencyView(.boldSumConfig(title: "Taxable Income", amount: stateTaxData.taxableStateIncome.amount))

                if stateTaxData.attributableIncome.rate.amount < 1.0 {
                    ExplainableRateView(attributableIncome: stateTaxData.attributableIncome)
                }
            }

            TaxListGroupView {
                ForEach(stateTaxData.taxes.indices, id: \.self) { idx in
                    let stateTax = stateTaxData.taxes[idx]
                    ExplainableCurrencyView(
                        CurrencyViewConfig(
                            title: "\(stateTax.title) Tax",
                            subtitle: "(\(stateTax.activeBracket.formattedString))",
                            amount: stateTax.taxAmount,
                            showSeparator: idx > 0
                        ), explanation: .taxInfo(stateTax)
                    )
                }

                if let localTax = stateTaxData.localTax {
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

        TaxListGroupView {
            TaxSummaryView(summary: stateTaxData.summary)
        }
    }
}

struct ExplainableRateView: View {
    let attributableIncome: AttributableIncome

    var body: some View {
        CurrencyView(CurrencyViewConfig(
            title: attributableIncome.incomeName,
            amount: attributableIncome.amount,
            showSeparator: true
        ))
        LabeledExplainableValueView(titleText: attributableIncome.rate.name,
                                    valueText: FormattingHelper.formatPercentage(attributableIncome.rate.amount),
                                    infoContent: CalculationExplanationView(attributableIncome))
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
                                  stateTaxData: exampleData.stateTaxDatas[0])
            StateTaxesListSection(isExpanded: $isExpanded2,
                                  isFirst: false,
                                  totalIncome: exampleData.totalIncome,
                                  stateTaxData: exampleData.stateTaxDatas[1])
        }
        .padding()
    }
}
