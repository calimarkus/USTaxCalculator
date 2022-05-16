//
//

struct TaxBracketGroup {
    let sortedBrackets: [TaxBracket]

    init(_ brackets: [TaxBracket]) {
        sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
    }

    func matchingBracketFor(taxableIncome: Double) throws -> TaxBracket {
        let matchingBracket = sortedBrackets.first { bracket in
            taxableIncome >= bracket.startingAt
        }

        if let b = matchingBracket {
            return b
        } else {
            throw TaxBracketFactoryError.noMatchingTaxBracketFound
        }
    }
}
