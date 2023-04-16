//
// IncomeAddition.swift
//

enum StateIncomeError: Error {
    case illegalStateIncomeAddition
    case illegalIncomeAmountAddition
}

extension Income {
    static func + (lhs: Income, rhs: Income) throws -> Income {
        try Income(
            wages: lhs.wages + rhs.wages,
            federalWithholdings: lhs.federalWithholdings + rhs.federalWithholdings,
            medicareWages: lhs.medicareWages + rhs.medicareWages,
            medicareWithholdings: lhs.medicareWithholdings + rhs.medicareWithholdings,
            dividendsAndInterests: lhs.dividendsAndInterests + rhs.dividendsAndInterests,
            capitalGains: lhs.capitalGains + rhs.capitalGains,
            longtermCapitalGains: lhs.longtermCapitalGains + rhs.longtermCapitalGains,
            stateIncomes: StateIncome.merge(lhs.stateIncomes, rhs.stateIncomes)
        )
    }
}

private extension IncomeAmount {
    func mergeWith(_ rhs: IncomeAmount) throws -> IncomeAmount {
        switch self {
            case .fullFederal:
                switch rhs {
                    case .fullFederal: return .fullFederal
                    case .partial: throw StateIncomeError.illegalIncomeAmountAddition
                }

            case let .partial(incomeLhs):
                switch rhs {
                    case .fullFederal: throw StateIncomeError.illegalIncomeAmountAddition
                    case let .partial(incomeRhs): return .partial(incomeLhs + incomeRhs)
                }
        }
    }
}

private extension StateIncome {
    private func mergeWith(_ rhs: StateIncome) throws -> StateIncome {
        guard state == rhs.state, localTax == rhs.localTax else {
            throw StateIncomeError.illegalStateIncomeAddition
        }
        return try StateIncome(
            state: state,
            wages: wages.mergeWith(rhs.wages),
            withholdings: withholdings + rhs.withholdings,
            additionalStateIncome: additionalStateIncome + rhs.additionalStateIncome,
            localTax: localTax
        )
    }

    static func merge(_ lhs: [StateIncome], _ rhs: [StateIncome]) throws -> [StateIncome] {
        var leftStates: [TaxState: StateIncome] = [:]
        lhs.forEach { leftStates[$0.state] = $0 }
        let mergedRightStateIncomes: [StateIncome] = try rhs.map {
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
