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
        rate = NamedValue(amount: amount / totalIncome.amount, name: "\(name) Rate")
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
