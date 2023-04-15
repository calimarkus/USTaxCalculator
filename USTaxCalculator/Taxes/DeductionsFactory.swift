//
//

enum DeductionsFactory {
    enum DeductionError: Error {
        case missingStandardDeduction
    }

    static func calculateDeductionsForDeductionAmount(_ amount: DeductionAmount, standardDeduction: Double?) throws -> Double {
        guard let standardDeduction else { throw DeductionError.missingStandardDeduction }

        switch amount {
            case let .standard(additional): return additional + standardDeduction
            case let .custom(customAmount): return customAmount
        }
    }

    static func calculateStateDeductions(for state: TaxState, filingType: FilingType, stateDeductions: [TaxState: DeductionAmount], taxRates: RawTaxRatesYear) throws -> Double {
        return try calculateDeductionsForDeductionAmount(
            stateDeductions[state] ?? DeductionAmount.standard(),
            standardDeduction: taxRates.standardDeductionForState(state)[filingType]
        )
    }
}
