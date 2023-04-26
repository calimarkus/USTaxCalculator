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
