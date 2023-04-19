//
// TaxBracketGroup.swift
//

import Foundation

struct TaxBracketGroup {
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
