//
//

enum StateIncomeError: Error {
    case illegalStateIncomeAddition
    case illegalIncomeAmountAddition
}

enum TaxState: Comparable, Hashable, Codable {
    case NY
    case CA
}

enum TaxCity: Comparable, Hashable, Codable {
    case NYC
}

enum LocalTaxType: Hashable, Codable {
    case none
    case city(_ city: TaxCity)
}

enum IncomeAmount: Hashable, Codable {
    case fullFederal
    case partial(_ income: Double)
}

struct StateIncome: Codable, Equatable {
    /// The state or city for this income
    var state: TaxState = TaxState.CA

    /// State Wages as listed on W-2, Box 16
    var wages: IncomeAmount = .fullFederal

    /// State Income Tax Withheld as listed on W-2, Box 17
    var withholdings = 0.0

    /// State Income that's not part of the wages on the W-2
    var additionalStateIncome = 0.0

    /// Any local taxes that apply to this state
    var localTax: LocalTaxType = .none
}

extension StateIncome {
    func incomeRateGivenFederalIncome(_ federalIncome: Double) -> Double {
        switch wages {
            case .fullFederal: return 1.0
            case let .partial(income): return income / federalIncome
        }
    }

    func attributableIncomeGivenFederalIncome(_ federalIncome: Double) -> Double {
        switch wages {
            case .fullFederal: return federalIncome
            case let .partial(income): return income
        }
    }
}

private extension IncomeAmount {
    func mergeWith(_ rhs: IncomeAmount) throws -> IncomeAmount {
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
    private func mergeWith(_ rhs: StateIncome) throws -> StateIncome {
        guard state == rhs.state, localTax == rhs.localTax else {
            throw StateIncomeError.illegalStateIncomeAddition
        }
        return StateIncome(
            state: state,
            wages: try wages.mergeWith(rhs.wages),
            withholdings: withholdings + rhs.withholdings,
            additionalStateIncome: additionalStateIncome + rhs.additionalStateIncome,
            localTax: localTax)
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
