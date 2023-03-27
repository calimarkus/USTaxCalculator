//
//

enum DeductionAmount: Hashable, Codable, Equatable {
    case standard(additionalDeductions: Double = 0.0)
    case custom(_ amount: Double)
}

extension DeductionAmount {
    static func stateAmount(_ amount: DeductionAmount, taxYear: TaxYear, state: TaxState, filingType: FilingType) -> Double {
        switch amount {
            case let .standard(additional): return additional + RawStandardDeductions.state(taxYear: taxYear, state: state, filingType: filingType)
            case let .custom(amount): return amount
        }
    }

    static func federalAmount(_ amount: DeductionAmount, taxYear: TaxYear, filingType: FilingType) -> Double {
        switch amount {
            case let .standard(additional): return additional + RawStandardDeductions.federal(taxYear: taxYear, filingType: filingType)
            case let .custom(amount): return amount
        }
    }
}
