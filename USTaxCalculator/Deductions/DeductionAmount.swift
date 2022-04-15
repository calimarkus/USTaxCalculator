//
//

enum DeductionAmountError: Error {
    case illegalDeductionAmountAddition
}

enum DeductionAmount {
    case standard(additionalDeductions:Double=0.0)
    case custom(_ amount:Double)
}

extension DeductionAmount {
    static func stateAmount(amount:DeductionAmount, taxYear:TaxYear, state:State, filingType:FilingType) -> Double {
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

extension DeductionAmount {
    func mergeWith(_ rhs:DeductionAmount) throws -> DeductionAmount {
        switch self {
            case let .standard(lhsAdditional): switch rhs {
                case let .standard(rhsAdditional): return DeductionAmount.standard(additionalDeductions: lhsAdditional + rhsAdditional)
                case .custom: throw DeductionAmountError.illegalDeductionAmountAddition // cannot combine custom & standard deductions
            }
            case let .custom(lhsAmount): switch rhs {
                case .standard: throw DeductionAmountError.illegalDeductionAmountAddition // cannot combine custom & standard deductions
                case let .custom(rhsAmount): return DeductionAmount.custom(lhsAmount + rhsAmount)
            }
        }
    }
}
