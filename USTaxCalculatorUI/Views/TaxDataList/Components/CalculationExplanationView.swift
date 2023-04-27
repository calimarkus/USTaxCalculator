//
// CalculationExplanationView.swift
//

import SwiftUI

struct CalculationExplanationView: View {
    let value: any CalculatableValue

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

    static var previews: some View {
        CalculationExplanationView(value: Deduction(input: input, standardDeduction: TaxYear2021_Single.taxRates.federalRates.standardDeductions))
            .padding(20.0)
    }
}
