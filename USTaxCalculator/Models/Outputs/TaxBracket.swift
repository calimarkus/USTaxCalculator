//
// TaxBracket.swift
//

enum BracketType: Hashable {
    /// applies the rate to the (income - startingAt) + fixedAmount
    case progressive(fixedAmount: Double)
    /// applies the given rate to the given income
    case basic
}

struct TaxBracket: Hashable {
    /// The rate that should be applied
    let rate: Double

    /// The minimum income for this bracket to apply
    let startingAt: Double

    /// The BracketType defines how the tax is calculated
    let type: BracketType
}

// convenience inits
extension TaxBracket {
    /// applies the rate to the (income - startingAt) + fixedAmount
    init(fixedAmount: Double, plus rate: Double, over startingAt: Double) {
        self.init(rate: rate, startingAt: startingAt, type: .progressive(fixedAmount: fixedAmount))
    }

    /// applies the given rate to the given income
    init(simpleRate: Double, startingAt: Double) {
        self.init(rate: simpleRate, startingAt: startingAt, type: .basic)
    }

    /// calculates the taxes for the given amount, respecting the bracket type
    func calculateTaxesForAmount(_ namedAmount: NamedValue) -> Double {
        switch type {
            case .basic:
                return namedAmount.amount * rate
            case let .progressive(fixedAmount):
                return fixedAmount + ((namedAmount.amount - startingAt) * rate)
        }
    }

    /// returns a string describing the calculation of the taxes for the given amount, respecting the bracket type
    func taxCalculationExplanation(_ namedAmount: NamedValue, explanationType: ExplanationType = .values) -> String {
        switch explanationType {
            case .names:
                switch type {
                    case .basic:
                        return "\(namedAmount.name) * Rate"
                    case let .progressive(fixedAmount):
                        let fixedAmountDesc = fixedAmount > 0.0 ? " + Fixed amount" : ""
                        return "(\(namedAmount.name) - Bracket start) * Rate\(fixedAmountDesc)"
                }
            case .values:
                return "\(taxCalculationExplanationForAmount(namedAmount)) = \(FormattingHelper.formatCurrency(calculateTaxesForAmount(namedAmount)))"
        }
    }

    private func taxCalculationExplanationForAmount(_ namedAmount: NamedValue) -> String {
        switch type {
            case .basic:
                return "\(FormattingHelper.formatCurrency(namedAmount.amount)) * \(FormattingHelper.formatPercentage(rate))"
            case let .progressive(fixedAmount):
                let fixedAmountText = fixedAmount > 0.0 ? " + \(FormattingHelper.formatCurrency(fixedAmount))" : ""
                return "(\(FormattingHelper.formatCurrency(namedAmount.amount)) - \(FormattingHelper.formatCurrency(startingAt))) * \(FormattingHelper.formatPercentage(rate))\(fixedAmountText)"
        }
    }
}
