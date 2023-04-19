//
// TaxInfoView.swift
//

import SwiftUI

struct TaxInfoView: View {
    let sortedBrackets: [TaxBracket]
    let tax: Tax

    init(tax: Tax) {
        sortedBrackets = tax.bracketGroup.sortedBrackets.reversed()
        self.tax = tax
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("\(tax.title) Tax Rates:")
                .font(.headline)
            BracketTableView(brackets: sortedBrackets, activeBracket: tax.activeBracket)

            Spacer().frame(height: 4.0)

            Text("Calculation:")
                .font(.headline)
            Text("\(tax.activeBracket.taxCalculationExplanation(tax.taxableIncome, explanationType: .names))")
                .padding(.bottom, -4.0)
                .foregroundColor(.secondary)
            Text("\(tax.activeBracket.taxCalculationExplanation(tax.taxableIncome)) = \(FormattingHelper.formatCurrency(tax.activeBracket.calculateTaxesForAmount(tax.taxableIncome)))")
                .font(.system(.body, design: .monospaced))

            if tax.bracketGroup.sources.count > 0 {
                Spacer().frame(height: 4.0)

                VStack(alignment: .leading, spacing: 5.0) {
                    Text("Sources:")
                        .font(.headline)
                    ForEach(tax.bracketGroup.sources, id: \.absoluteString) { source in
                        Link(source.absoluteString, destination: source)
                            .font(.subheadline)
                            .opacity(0.66)
                            .lineLimit(1)
                        #if os(macOS)
                            .font(.caption2)
                        #endif
                    }
                }
            }

            Spacer().frame(height: 4.0)
        }
        .padding(20.0)
        #if os(macOS)
            .frame(minWidth: 500)
        #endif
    }
}

struct TaxInfoView_Previews: PreviewProvider {
    static let fedBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2020_MarriedJointly.taxRates.federalRates.incomeRates)
    static let longtermGainsBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2020_MarriedJointly.taxRates.federalRates.longtermGainsRates)

    static var previews: some View {
        TaxInfoView(tax: FederalTax(
            title: "Preview Income",
            activeBracket: fedBrackets.sortedBrackets[3],
            bracketGroup: fedBrackets,
            taxableIncome: NamedValue(amount: 92720, name: "Taxable Income")
        ))

        TaxInfoView(tax: FederalTax(
            title: "Preview Income",
            activeBracket: longtermGainsBrackets.sortedBrackets[1],
            bracketGroup: longtermGainsBrackets,
            taxableIncome: NamedValue(amount: 246_000, name: "Taxable Income")
        ))
    }
}
