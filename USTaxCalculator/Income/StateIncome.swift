//
//

enum StateIncomeError: Error {
    case illegalStateIncomeAddition
    case illegalIncomeAmountAddition
}

enum StateOrCity : Comparable, Hashable {
    case NY
    case NYC
    case CA
}

enum IncomeAmount {
    case fullFederal
    case partial(_ income:Double)
}

struct StateIncome {
    /// The state or city for this income
    let state:StateOrCity

    /// State Wages as listed on W-2, Box 16
    let wages:IncomeAmount

    /// State Income Tax Withheld as listed on W-2, Box 17
    let withholdings:Double

    /// State deductions that apply. .standard will utilize standard deductions
    var deductions:DeductionAmount = DeductionAmount.standard()

    /// State Income that's not part of the wages on the W-2
    var additionalStateIncome:Double = 0.0
}

extension StateIncome {
    func incomeRateFor(federalIncome:Double) -> Double {
        switch wages {
            case .fullFederal: return 1.0
            case let .partial(income): return income / federalIncome
        }
    }
}

extension IncomeAmount {
    fileprivate func mergeWith(_ rhs:IncomeAmount) throws -> IncomeAmount {
        switch self {
            case .fullFederal: switch rhs {
                case .fullFederal: return .fullFederal
                case .partial: throw StateIncomeError.illegalIncomeAmountAddition
            }
            case let .partial(incomeLhs): switch rhs {
                case .fullFederal: throw StateIncomeError.illegalIncomeAmountAddition
                case let .partial(incomeRhs): return .partial(incomeLhs + incomeRhs)
            }
        }
    }
}

extension StateIncome {
    private func mergeWith(_ rhs:StateIncome) throws -> StateIncome {
        guard state == rhs.state else {
            throw StateIncomeError.illegalStateIncomeAddition
        }
        return StateIncome(
            state: state,
            wages: try wages.mergeWith(rhs.wages),
            withholdings: withholdings + rhs.withholdings,
            deductions: try deductions.mergeWith(rhs.deductions),
            additionalStateIncome: additionalStateIncome + rhs.additionalStateIncome)
    }

    static func merge(_ lhs:[StateIncome], _ rhs:[StateIncome]) throws -> [StateIncome] {
        var leftStates:[StateOrCity : StateIncome] = [:]
        lhs.forEach { leftStates[$0.state] = $0 }
        let mergedRightStateIncomes:[StateIncome] = try rhs.map {
            if let matchingLeft = leftStates[$0.state] {
                let merged = try matchingLeft.mergeWith($0)
                leftStates.removeValue(forKey: $0.state)
                return merged
            } else {
                return $0
            }
        }

        return mergedRightStateIncomes + leftStates.values
    }
}
