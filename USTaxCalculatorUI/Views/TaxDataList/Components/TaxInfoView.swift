//
// TaxInfoView.swift
//

import SwiftUI
import TaxOutputModels
import TaxPrimitives
import TaxRates
import TaxCalculator
import TaxFormatter

struct TaxInfoView: View {
    let sortedBrackets: [TaxBracket]
    let tax: any ExplainableTax

    init(_ tax: any ExplainableTax) {
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
    static let ratesGroup = RawTaxRatesGroup.taxRatesGroup(for: .y2020, .marriedJointly)
    static let fedBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.federalRates.incomeRates)
    static let caliBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.rawStateTaxRates(for: .CA).incomeRates(forIncome: 200_000))
    static let longtermGainsBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.federalRates.longtermGainsRates)

    static var previews: some View {
        TaxInfoView(BasicTax(
            title: "Federal Income",
            activeBracket: fedBrackets.sortedBrackets[3],
            bracketGroup: fedBrackets,
            taxableIncome: NamedValue(92720, named: "Taxable Income")
        ))

        TaxInfoView(AttributableTax(
            title: "CA State",
            activeBracket: caliBrackets.sortedBrackets[5],
            bracketGroup: caliBrackets,
            taxableIncome: NamedValue(150_000, named: "CA State Income"),
            attributedRate: NamedValue(1.0, named: "")
        )).frame(maxWidth: 500)

        TaxInfoView(BasicTax(
            title: "Preview Income",
            activeBracket: longtermGainsBrackets.sortedBrackets[1],
            bracketGroup: longtermGainsBrackets,
            taxableIncome: NamedValue(246_000, named: "Taxable Income")
        ))
    }
}
