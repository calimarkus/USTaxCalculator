//
// StateIncome.swift
//

import TaxPrimitives

public enum IncomeAmount: Hashable, Codable {
    case fullFederal
    case partial(_ income: Double)
}

public struct StateIncome: Codable, Equatable {
    /// The state or city for this income
    public var state: TaxState = .CA

    /// State Wages as listed on W-2, Box 16
    public var wages: IncomeAmount = .fullFederal

    /// State Income Tax Withheld as listed on W-2, Box 17
    public var withholdings = 0.0

    /// State Income that's not part of the wages on the W-2
    public var additionalStateIncome = 0.0

    /// Any local taxes that apply to this state
    public var localTax: LocalTaxType = .none

    public init(state: TaxState = .CA, wages: IncomeAmount = .fullFederal, withholdings: Double = 0.0, additionalStateIncome: Double = 0.0, localTax: LocalTaxType = .none) {
        self.state = state
        self.wages = wages
        self.withholdings = withholdings
        self.additionalStateIncome = additionalStateIncome
        self.localTax = localTax
    }
}
