//
// StateAttributedIncome.swift
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
    private let name: String
    private let totalIncome: NamedValue

    let amount: Double
    let incomeName: String
    let rate: NamedValue

    init(name: String, incomeAmount: IncomeAmount, totalIncome: NamedValue) {
        self.name = name
        self.totalIncome = totalIncome

        amount = incomeAmount.calculate(for: totalIncome.amount)
        incomeName = "Attributable \(name)"
        rate = NamedValue(amount: amount / totalIncome.amount, name: "\(name) Rate")
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
