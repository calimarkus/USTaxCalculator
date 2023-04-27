//
// StateAttributedIncome.swift
//

struct StateAttributedIncome {
    let incomeAmount: IncomeAmount
    private let federalIncome: NamedValue

    init(incomeAmount: IncomeAmount, federalIncome: NamedValue) {
        self.incomeAmount = incomeAmount
        self.federalIncome = federalIncome
    }

    /// The income rate for this state - stateAttributableIncome / totalIncome (only relevant in multi state situations)
    var rate: Double {
        switch incomeAmount {
            case .fullFederal: return 1.0
            case let .partial(income): return income / federalIncome.amount
        }
    }

    /// An explanation of how the incomeRate was calculated
    func rateExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                switch incomeAmount {
                    case .fullFederal: return "\(federalIncome.name)"
                    case .partial: return "State Attributed Income / \(federalIncome.name)"
                }
            case .values:
                var explanation = "\(FormattingHelper.formatCurrency(amount))"
                explanation += " / \(FormattingHelper.formatCurrency(federalIncome.amount))"
                explanation += " = \(FormattingHelper.formatPercentage(rate))"
                return explanation
        }
    }

    /// The income attributed to this state (only relevant in multi state situations)
    var amount: Double {
        switch incomeAmount {
            case .fullFederal: return federalIncome.amount
            case let .partial(income): return income
        }
    }
}

extension StateAttributedIncome: CalculatableValue {
    func calculateAmount() -> Double { rate }
    func calculationExplanation(as type: ExplanationType) -> String { rateExplanation(as: type) }
}
