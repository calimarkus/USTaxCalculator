//
// TaxBracket.swift
//

indirect enum BracketType: Hashable {
    /// applies the given rate to the given income
    case basic
    /// calculates the rate based on the closest two matches and applies that to the given income
    case interpolated(lowerBracket: TaxBracket, higherBracket: TaxBracket)
    /// applies the rate to the (income - startingAt) + fixedAmount
    case progressive(fixedAmount: Double)
}

struct TaxBracket: Hashable {
    /// The rate that should be applied
    let rate: Double

    /// The minimum income for this bracket to apply
    let startingAt: Double

    /// The BracketType defines how the tax is calculated
    let type: BracketType

    init(rate: Double, startingAt: Double, type: BracketType = .basic) {
        self.rate = rate
        self.startingAt = startingAt
        self.type = type
    }
}

// convenience inits
extension TaxBracket {
    /// applies the given rate to the given income
    init(interpolatedRateStartingAt startingAt: Double, lowerBracket: TaxBracket, higherBracket: TaxBracket) {
        let interpolatedRate = lowerBracket.rate + (higherBracket.rate - lowerBracket.rate) / 2.0
        self.init(rate: interpolatedRate, startingAt: startingAt, type: .interpolated(lowerBracket: lowerBracket, higherBracket: higherBracket))
    }

    /// applies the rate to the (income - startingAt) + fixedAmount
    init(fixedAmount: Double, plus rate: Double, over startingAt: Double) {
        self.init(rate: rate, startingAt: startingAt, type: .progressive(fixedAmount: fixedAmount))
    }
}

// tax calculations
extension TaxBracket {
    /// calculates the taxes for the given amount, respecting the bracket type
    func calculateTaxes(for namedTaxableAmount: NamedValue) -> Double {
        switch type {
            case .basic:
                return namedTaxableAmount.amount * rate
            case .interpolated:
                return namedTaxableAmount.amount * rate // the interpolated rate is calculated in init
            case let .progressive(fixedAmount):
                return fixedAmount + ((namedTaxableAmount.amount - startingAt) * rate)
        }
    }

    /// returns a string describing the calculation of the taxes for the given amount, respecting the bracket type
    func taxCalculationExplanation(for namedTaxableAmount: NamedValue, explanationType: ExplanationType = .values, includeTotalValue: Bool = true) -> String {
        switch explanationType {
            case .names:
                switch type {
                    case .basic:
                        return "\(namedTaxableAmount.name) * Rate"
                    case .interpolated:
                        return "\(namedTaxableAmount.name) * (lower rate + (higher rate - lower rate) / 2.0))"
                    case let .progressive(fixedAmount):
                        let fixedAmountDesc = fixedAmount > 0.0 ? " + Fixed amount" : ""
                        return "(\(namedTaxableAmount.name) - Bracket start) * Rate\(fixedAmountDesc)"
                }
            case .values:
                var explanation = calculationExplanationWithoutSum(for: namedTaxableAmount)
                if includeTotalValue {
                    explanation += " = \(FormattingHelper.formatCurrency(calculateTaxes(for: namedTaxableAmount)))"
                }
                return explanation
        }
    }

    private func calculationExplanationWithoutSum(for namedTaxableAmount: NamedValue) -> String {
        switch type {
            case .basic:
                return "\(FormattingHelper.formatCurrency(namedTaxableAmount.amount)) * \(FormattingHelper.formatPercentage(rate))"
            case let .interpolated(lowerBracket, higherBracket):
                return "\(FormattingHelper.formatCurrency(namedTaxableAmount.amount)) * (\(FormattingHelper.formatPercentage(lowerBracket.rate)) + (\(FormattingHelper.formatPercentage(lowerBracket.rate)) - \(FormattingHelper.formatPercentage(higherBracket.rate))) / 2.0)"
            case let .progressive(fixedAmount):
                let fixedAmountText = fixedAmount > 0.0 ? " + \(FormattingHelper.formatCurrency(fixedAmount))" : ""
                return "(\(FormattingHelper.formatCurrency(namedTaxableAmount.amount)) - \(FormattingHelper.formatCurrency(startingAt))) * \(FormattingHelper.formatPercentage(rate))\(fixedAmountText)"
        }
    }
}
