//
// StateAttributedIncome.swift
//

struct AttributableIncome {
    private let name: String
    private let incomeAmount: IncomeAmount
    private let totalIncome: NamedValue

    var incomeName: String { "Attributable \(name)" }

    init(name: String, incomeAmount: IncomeAmount, totalIncome: NamedValue) {
        self.name = name
        self.incomeAmount = incomeAmount
        self.totalIncome = totalIncome
    }

    /// The income rate for this state - stateAttributableIncome / totalIncome (only relevant in multi state situations)
    var rate: Double {
        switch incomeAmount {
            case .fullFederal: return 1.0
            case let .partial(income): return income / totalIncome.amount
        }
    }

    var namedRate: NamedValue {
        NamedValue(amount: rate, name: "\(name) Rate")
    }

    /// An explanation of how the incomeRate was calculated
    func rateExplanation(as type: ExplanationType) -> String {
        switch type {
            case .names:
                switch incomeAmount {
                    case .fullFederal: return "\(totalIncome.name)"
                    case .partial: return "\(incomeName) / \(totalIncome.name)"
                }
            case .values:
                var explanation = "\(FormattingHelper.formatCurrency(amount)) / \(FormattingHelper.formatCurrency(totalIncome.amount))"
                explanation += " = \(FormattingHelper.formatPercentage(rate))"
                return explanation
        }
    }

    /// The income attributed to this state (only relevant in multi state situations)
    var amount: Double {
        switch incomeAmount {
            case .fullFederal: return totalIncome.amount
            case let .partial(income): return income
        }
    }
}

extension AttributableIncome: ExplainableValue {
    func calculationExplanation(as type: ExplanationType) -> String { rateExplanation(as: type) }
}
