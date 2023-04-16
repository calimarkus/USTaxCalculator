//
//

enum DeductionsFactory {
    static func calculateDeductionsForDeductionAmount(_ amount: DeductionAmount, standardDeduction: Double) -> Double {
        switch amount {
        case let .standard(additional): return additional + standardDeduction
        case let .custom(customAmount): return customAmount
        }
    }

    static func calculateStateDeductions(for state: TaxState, stateDeductions: [TaxState: DeductionAmount], taxRates: RawTaxRatesYear) -> Double {
        calculateDeductionsForDeductionAmount(
            stateDeductions[state] ?? DeductionAmount.standard(),
            standardDeduction: taxRates.standardDeductionForState(state)
        )
    }
}
