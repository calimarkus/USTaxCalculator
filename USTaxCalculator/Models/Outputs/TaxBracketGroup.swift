//
// TaxBracketGroup.swift
//

import Foundation

protocol TaxBracketGroup {
    var sortedBrackets: [TaxBracket] { get }
    var sources: [URL] { get }

    func matchingBracketFor(taxableIncome: Double) -> TaxBracket
}

struct RegularTaxBracketGroup: TaxBracketGroup {
    let sortedBrackets: [TaxBracket]
    let sources: [URL]

    init(_ brackets: [TaxBracket], sources: [URL] = []) {
        sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
        self.sources = sources
    }

    func matchingBracketFor(taxableIncome: Double) -> TaxBracket {
        let matchingBracket = sortedBrackets.first { bracket in
            taxableIncome >= bracket.startingAt
        }

        return matchingBracket ?? TaxBracket(simpleRate: 0.0, startingAt: 0.0)
    }
}

struct InterpolatedTaxBracketGroup: TaxBracketGroup {
    let sortedBrackets: [TaxBracket]
    let sources: [URL]

    init(_ brackets: [TaxBracket], sources: [URL] = []) {
        sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
        self.sources = sources
    }

    func matchingBracketFor(taxableIncome: Double) -> TaxBracket {
        var bracketBefore: TaxBracket = sortedBrackets.first!
        var bracketAfter: TaxBracket = sortedBrackets.first!
        for bracket in sortedBrackets {
            if taxableIncome >= bracket.startingAt {
                bracketAfter = bracket
                break
            }
            bracketBefore = bracket
        }

        // interpolate between two rates
        let interpolatedRate = bracketBefore.rate + (bracketAfter.rate - bracketBefore.rate) / 2.0
        return TaxBracket(simpleRate: interpolatedRate, startingAt: taxableIncome)
    }
}
