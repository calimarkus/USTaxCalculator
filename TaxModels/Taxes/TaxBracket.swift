//
// TaxBracket.swift
//

indirect public enum BracketType: Hashable {
    /// applies the given rate to the given income
    case basic
    /// calculates the rate based on the closest two matches and applies that to the given income
    case interpolated(lowerBracket: TaxBracket, higherBracket: TaxBracket)
    /// applies the rate to the (income - startingAt) + fixedAmount
    case progressive(fixedAmount: Double)
}

public struct TaxBracket: Hashable {
    /// The rate that should be applied
    public let rate: Double

    /// The minimum income for this bracket to apply
    public let startingAt: Double

    /// The BracketType defines how the tax is calculated
    public let type: BracketType

    public init(rate: Double, startingAt: Double, type: BracketType = .basic) {
        self.rate = rate
        self.startingAt = startingAt
        self.type = type
    }
}

// convenience inits
public extension TaxBracket {
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

// tax calculation
public extension TaxBracket {
    /// calculates the taxes for the given amount, respecting the bracket type
    func calculateTaxes(for namedTaxableAmount: NamedValue, attributableRate: NamedValue? = nil) -> Double {
        var taxes = taxesWithoutAttributableRate(for: namedTaxableAmount)
        if let attributableRate {
            taxes *= attributableRate.amount
        }
        return taxes
    }

    private func taxesWithoutAttributableRate(for namedTaxableAmount: NamedValue) -> Double {
        switch type {
            case .basic:
                return namedTaxableAmount.amount * rate
            case .interpolated:
                return namedTaxableAmount.amount * rate // the interpolated rate is calculated in init
            case let .progressive(fixedAmount):
                return fixedAmount + ((namedTaxableAmount.amount - startingAt) * rate)
        }
    }
}
