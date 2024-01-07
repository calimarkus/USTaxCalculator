//
// TaxBracketGroup.swift
//

import Foundation

public protocol TaxBracketGroup {
    var sortedBrackets: [TaxBracket] { get }
    var sources: [URL] { get }

    func matchingBracketFor(taxableIncome: Double) -> TaxBracket
}

public struct RegularTaxBracketGroup: TaxBracketGroup {
    public let sortedBrackets: [TaxBracket]
    public let sources: [URL]

    public init(_ brackets: [TaxBracket], sources: [URL] = []) {
        sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
        self.sources = sources
    }

    public func matchingBracketFor(taxableIncome: Double) -> TaxBracket {
        let matchingBracket = sortedBrackets.first { bracket in
            taxableIncome >= bracket.startingAt
        }

        return matchingBracket ?? TaxBracket(rate: 0.0, startingAt: 0.0)
    }
}

public struct InterpolatedTaxBracketGroup: TaxBracketGroup {
    public let sortedBrackets: [TaxBracket]
    public let sources: [URL]

    public init(_ brackets: [TaxBracket], sources: [URL] = []) {
        sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
        self.sources = sources
    }

    public func matchingBracketFor(taxableIncome: Double) -> TaxBracket {
        var higherBracket: TaxBracket = sortedBrackets.first!
        var lowerBracket: TaxBracket = sortedBrackets.first!
        for bracket in sortedBrackets {
            if taxableIncome >= bracket.startingAt {
                lowerBracket = bracket
                break
            }
            higherBracket = bracket
        }
        return TaxBracket(interpolatedRateStartingAt: taxableIncome, lowerBracket: lowerBracket, higherBracket: higherBracket)
    }
}
