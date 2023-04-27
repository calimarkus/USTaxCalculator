//
// DeductionInfoView.swift
//

import SwiftUI

struct DeductionInfoView: View {
    let deduction: Deduction

    init(_ deduction: Deduction) {
        self.deduction = deduction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            CalculationExplanationView(value: deduction)

            if deduction.sources.count > 0 {
                Spacer().frame(height: 4.0)
                SourcesListView(sources: deduction.sources)
            }

            Spacer().frame(height: 4.0)
        }
        .padding(20.0)
    }
}

struct DeductionInfoView_Previews: PreviewProvider {
    static let someDeduction = Deduction(input: DeductionInput.standard(), standardDeduction: TaxYear2020_MarriedJointly.taxRates.federalRates.standardDeductions)

    static var previews: some View {
        DeductionInfoView(someDeduction)
    }
}