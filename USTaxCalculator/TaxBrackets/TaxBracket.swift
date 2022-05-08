//
//

enum BracketType: Hashable {
    // applies the rate to the (income - startingAt) + fixedAmount
    case progressive(fixedAmount: Double)
    // applies the rate to the total income
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
    init(fixedAmount: Double, plus rate: Double, over startingAt: Double) {
        self.init(rate: rate, startingAt: startingAt, type: .progressive(fixedAmount: fixedAmount))
    }

    init(simpleRate: Double, startingAt: Double) {
        self.init(rate: simpleRate, startingAt: startingAt, type: .basic)
    }
}

extension TaxBracket {
    func calculateTaxesForAmount(_ amount: Double) -> Double {
        switch type {
            case .basic:
                return amount * rate
            case let .progressive(fixedAmount):
                return fixedAmount + ((amount - startingAt) * rate)
        }
    }

    func taxCalculationExplanation(_ amount: Double) -> String {
        switch type {
            case .basic:
                return "\(FormattingHelper.formatCurrency(amount)) * \(FormattingHelper.formatPercentage(rate))"
            case let .progressive(fixedAmount):
                return "\(FormattingHelper.formatCurrency(fixedAmount)) + (\(FormattingHelper.formatCurrency(amount)) - \(FormattingHelper.formatCurrency(startingAt))) * \(FormattingHelper.formatPercentage(rate))"
        }
    }
}
