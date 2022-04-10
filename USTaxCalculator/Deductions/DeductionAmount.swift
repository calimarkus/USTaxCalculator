//
//

enum DeductionAmount {
    case standard(additionalDeductions:Double=0.0)
    case custom(_ amount:Double)
}

extension DeductionAmount {
    static func stateAmount(amount:DeductionAmount, taxYear:TaxYear, state:StateOrCity, filingType:FilingType) -> Double {
        switch amount {
            case let .standard(additional): return additional + StandardDeductions.state(taxYear: taxYear, state: state, filingType: filingType)
            case let .custom(amount): return amount
        }
    }
    static func federalAmount(amount:DeductionAmount, taxYear:TaxYear, filingType:FilingType) -> Double {
        switch amount {
            case let .standard(additional): return additional + StandardDeductions.federal(taxYear: taxYear, filingType: filingType)
            case let .custom(amount): return amount
        }
    }
}
