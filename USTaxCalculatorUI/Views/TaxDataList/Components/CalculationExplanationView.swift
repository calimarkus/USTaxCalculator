//
// CalculationExplanationView.swift
//

import SwiftUI
import TaxIncomeModels
import TaxOutputModels
import TaxFormatter
import TaxRates
import TaxPrimitives
import TaxCalculator

struct CalculationExplanationView: View {
    let value: any ExplainableValue

    init(_ value: any ExplainableValue) {
        self.value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("Calculation:")
                .font(.headline)
            Text(value.calculationExplanation(as: .names))
                .padding(.bottom, -4.0)
                .foregroundColor(.secondary)
            Text("\(value.calculationExplanation(as: .values))")
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct CalculationExplanationView_Previews: PreviewProvider {
    static let ratesGroup = RawTaxRatesGroup.taxRatesGroup(for: .y2020, .marriedJointly)
    static let kind: DeductionKind = .standard(additionalDeductions: 500.0)
    static let caliBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.rawStateTaxRates(for: .CA).incomeRates(forIncome: 200_000))

    static var previews: some View {
        CalculationExplanationView(Deduction(
            kind: kind,
            standardDeduction: RawTaxRatesGroup.taxRatesGroup(for: .y2021, .single).federalRates.standardDeductions
        )).padding(20.0)

        CalculationExplanationView(AttributableTax(
            title: "CA State",
            activeBracket: caliBrackets.sortedBrackets[5],
            bracketGroup: caliBrackets,
            taxableIncome: NamedValue(80000, named: "CA State Income"),
            attributedRate: NamedValue(1.0, named: "")
        )).frame(width: 400).padding(20.0)
    }
}
