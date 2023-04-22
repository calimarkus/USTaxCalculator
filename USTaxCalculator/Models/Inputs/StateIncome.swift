//
// StateIncome.swift
//

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
    var state: TaxState = .CA

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
