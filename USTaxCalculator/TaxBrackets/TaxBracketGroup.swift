//
//

struct TaxBracketGroup {
    let sortedBrackets: [TaxBracket]

    init(_ brackets: [TaxBracket]) {
        sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
    }

    func matchingBracketFor(taxableIncome: Double) -> TaxBracket {
        let matchingBracket = sortedBrackets.first { bracket in
            taxableIncome >= bracket.startingAt
        }

        return matchingBracket ?? TaxBracket(simpleRate: 0.0, startingAt: 0.0)
    }
}
