//
// TaxInfoView.swift
//

import SwiftUI

struct TaxInfoView: View {
    let sortedBrackets: [TaxBracket]
    let tax: any Tax

    init(_ tax: any Tax) {
        sortedBrackets = tax.bracketGroup.sortedBrackets.reversed()
        self.tax = tax
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("\(tax.title) Tax Rates:")
                .font(.headline)
            BracketTableView(brackets: sortedBrackets, activeBracket: tax.activeBracket)

            Spacer().frame(height: 4.0)

            CalculationExplanationView(tax)
                .fixedSize(horizontal: false, vertical: true)

            if tax.bracketGroup.sources.count > 0 {
                Spacer().frame(height: 4.0)
                SourcesListView(sources: tax.bracketGroup.sources)
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
    static let rates = RawTaxRates2020.rates(for: .marriedJointly)
    static let fedBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(rates.federalRates.incomeRates)
    static let caliBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(rates.californiaRates.incomeRates)
    static let longtermGainsBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(rates.federalRates.longtermGainsRates)

    static var previews: some View {
        TaxInfoView(BasicTax(
            title: "Federal Income",
            activeBracket: fedBrackets.sortedBrackets[3],
            bracketGroup: fedBrackets,
            taxableIncome: NamedValue(amount: 92720, name: "Taxable Income")
        ))

        TaxInfoView(AttributableTax(
            title: "CA State",
            activeBracket: caliBrackets.sortedBrackets[5],
            bracketGroup: caliBrackets,
            taxableIncome: NamedValue(amount: 150_000, name: "CA State Income"),
            attributedRate: NamedValue(amount: 1.0, name: "")
        )).frame(maxWidth: 500)

        TaxInfoView(BasicTax(
            title: "Preview Income",
            activeBracket: longtermGainsBrackets.sortedBrackets[1],
            bracketGroup: longtermGainsBrackets,
            taxableIncome: NamedValue(amount: 246_000, name: "Taxable Income")
        ))
    }
}
