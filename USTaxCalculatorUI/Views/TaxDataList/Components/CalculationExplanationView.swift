//
// CalculationExplanationView.swift
//

import SwiftUI

struct CalculationExplanationView: View {
    let value: any CalculatableValue

    init(_ value: any CalculatableValue) {
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
    static let input: DeductionInput = .standard(additionalDeductions: 500.0)
    static let caliBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2020_MarriedJointly.taxRates.californiaRates.incomeRates)

    static var previews: some View {
        CalculationExplanationView(Deduction(
            input: input,
            standardDeduction: TaxYear2021_Single.taxRates.federalRates.standardDeductions
        )).padding(20.0)

        CalculationExplanationView(StateTax(
            state: .CA,
            activeBracket: caliBrackets.sortedBrackets[5],
            bracketGroup: caliBrackets,
            taxableIncome: NamedValue(amount: 150_000, name: "CA State Income"),
            incomeRate: 0.66,
            incomeRateExplanation: "Rate explanation.."
        )).frame(width: 400).padding(20.0)
    }
}
