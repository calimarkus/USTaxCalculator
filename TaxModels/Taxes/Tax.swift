//
// Tax.swift
//

public protocol Tax {
    /// The title for this tax
    var title: String { get }

    /// The active TaxBracket
    var activeBracket: TaxBracket { get }

    /// The underlying TaxBracketGroup
    var bracketGroup: TaxBracketGroup { get }

    /// The taxable income for this specific Bracket
    var taxableIncome: NamedValue { get }

    /// The tax amount
    var taxAmount: Double { get }
}

public struct BasicTax: Tax {
    /// The name of this tax
    public let title: String

    /// The active TaxBracket
    public let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    public let bracketGroup: TaxBracketGroup

    /// The taxable income for this specific Bracket
    public let taxableIncome: NamedValue

    public init(title: String, activeBracket: TaxBracket, bracketGroup: TaxBracketGroup, taxableIncome: NamedValue) {
        self.title = title
        self.activeBracket = activeBracket
        self.bracketGroup = bracketGroup
        self.taxableIncome = taxableIncome
    }

    /// The taxes coming from this bracket
    public var taxAmount: Double { activeBracket.calculateTaxes(for: taxableIncome) }
}

/// See this source: https://turbotax.intuit.com/tax-tips/state-taxes/multiple-states-figuring-whats-owed-when-you-live-and-work-in-more-than-one-state/L79OKm3jI
/// It is currently using the "Common method 1" for multi state taxes.
public struct AttributableTax: Tax {
    /// The name of this tax
    public let title: String

    /// The active TaxBracket
    public let activeBracket: TaxBracket

    /// The underlying TaxBracketGroup
    public let bracketGroup: TaxBracketGroup

    /// The taxable income for this state
    public let taxableIncome: NamedValue

    /// The rate of the taxable income, which this tax applies to
    public let attributedRate: NamedValue

    public init(title: String, activeBracket: TaxBracket, bracketGroup: TaxBracketGroup, taxableIncome: NamedValue, attributedRate: NamedValue) {
        self.title = title
        self.activeBracket = activeBracket
        self.bracketGroup = bracketGroup
        self.taxableIncome = taxableIncome
        self.attributedRate = attributedRate
    }

    /// The taxes coming from this state
    public var taxAmount: Double {
        activeBracket.calculateTaxes(for: taxableIncome) * attributedRate.amount
    }
}
