//
// AttributableIncome.swift
//

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

struct AttributableIncome: ExplainableValue {
    let amount: Double
    let incomeName: String
    let rate: NamedValue
    private let totalIncome: NamedValue

    init(name: String, incomeAmount: IncomeAmount, totalIncome: NamedValue) {
        amount = incomeAmount.calculate(for: totalIncome.amount)
        incomeName = "Attributable \(name)"
        let rateValue = (totalIncome.amount > 0.0 ? amount / totalIncome.amount : 0.0)
        rate = NamedValue(rateValue, named: "\(name) Rate")
        self.totalIncome = totalIncome
    }

    /// An explanation of how the rate was calculated
    func calculationExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                return "\(incomeName) / \(totalIncome.name)"
            case .values:
                var explanation = "\(FormattingHelper.formatCurrency(amount)) / \(FormattingHelper.formatCurrency(totalIncome.amount))"
                explanation += " = \(FormattingHelper.formatPercentage(rate.amount))"
                return explanation
        }
    }
}
