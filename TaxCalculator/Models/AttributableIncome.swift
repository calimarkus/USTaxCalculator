//
// AttributableIncome.swift
//

import TaxModels

private extension IncomeAmount {
    func calculate(for totalIncome: Double) -> Double {
        switch self {
            case .fullFederal:
                return totalIncome
            case let .partial(income):
                return income
        }
    }
}

public struct AttributableIncome {
    public let amount: Double
    public let incomeName: String
    public let rate: NamedValue
    
    public let totalIncome: NamedValue

    public init(name: String, incomeAmount: IncomeAmount, totalIncome: NamedValue) {
        amount = incomeAmount.calculate(for: totalIncome.amount)
        incomeName = "Attributable \(name)"
        let rateValue = (totalIncome.amount > 0.0 ? amount / totalIncome.amount : 0.0)
        rate = NamedValue(rateValue, named: "\(name) Rate")
        self.totalIncome = totalIncome
    }
}
