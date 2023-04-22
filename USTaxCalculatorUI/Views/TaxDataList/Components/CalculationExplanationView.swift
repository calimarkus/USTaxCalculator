//
// CalculationExplanationView.swift
//

import SwiftUI

struct CalculationExplanationView: View {
    let explanation: String
    let calculation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("Calculation:")
                .font(.headline)
            Text(explanation)
                .padding(.bottom, -4.0)
                .foregroundColor(.secondary)
            Text(calculation)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct CalculationExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationExplanationView(
            explanation: "This + that",
            calculation: "50 + 20"
        )
        .padding(20.0)
    }
}
