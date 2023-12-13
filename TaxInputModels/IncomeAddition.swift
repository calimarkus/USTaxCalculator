//
// IncomeAddition.swift
//

import TaxPrimitives

public enum StateIncomeError: Error {
    case illegalStateIncomeAddition
    case illegalIncomeAmountAddition
}

public extension Income {
    static func + (lhs: Income, rhs: Income) throws -> Income {
        Income(
            wages: lhs.wages + rhs.wages,
            federalWithholdings: lhs.federalWithholdings + rhs.federalWithholdings,
            medicareWages: lhs.medicareWages + rhs.medicareWages,
            medicareWithholdings: lhs.medicareWithholdings + rhs.medicareWithholdings,
            dividendsAndInterests: lhs.dividendsAndInterests + rhs.dividendsAndInterests,
            capitalGains: lhs.capitalGains + rhs.capitalGains,
            longtermCapitalGains: lhs.longtermCapitalGains + rhs.longtermCapitalGains,
            stateIncomes: try StateIncome.mergeMatchingStateIncomes(lhs.stateIncomes, rhs.stateIncomes)
        )
    }
}

private extension IncomeAmount {
    static func + (lhs: IncomeAmount, rhs: IncomeAmount) throws -> IncomeAmount {
        switch lhs {
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
    static func + (lhs: StateIncome, rhs: StateIncome) throws -> StateIncome {
        guard lhs.state == rhs.state, lhs.localTax == rhs.localTax else {
            throw StateIncomeError.illegalStateIncomeAddition
        }
        return StateIncome(
            state: lhs.state,
            wages: try lhs.wages + rhs.wages,
            withholdings: lhs.withholdings + rhs.withholdings,
            additionalStateIncome: lhs.additionalStateIncome + rhs.additionalStateIncome,
            localTax: lhs.localTax
        )
    }

    static func mergeMatchingStateIncomes(_ lhs: [StateIncome], _ rhs: [StateIncome]) throws -> [StateIncome] {
        var leftStates: [TaxState: StateIncome] = [:]
        lhs.forEach { leftStates[$0.state] = $0 }

        let mergedRightStateIncomes: [StateIncome] = try rhs.map { rhsIncome in
            if let matchingLeft = leftStates[rhsIncome.state] {
                let merged = try matchingLeft + rhsIncome
                leftStates.removeValue(forKey: rhsIncome.state)
                return merged
            } else {
                return rhsIncome
            }
        }

        return mergedRightStateIncomes + leftStates.values
    }
}
