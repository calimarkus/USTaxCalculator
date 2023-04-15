//
//

enum TaxBracketGeneratorError: Error {
    case missingTaxRates
}

enum TaxBracketGenerator {
    static func bracketsForRawTaxRates(_ rawTaxRates: RawTaxRates?) throws -> TaxBracketGroup {
        guard let rawTaxRates else { throw TaxBracketGeneratorError.missingTaxRates }

        switch rawTaxRates.type {
            case .simple:
                return simpleBracketsForRawTaxRates(rawTaxRates)
            case .progressive:
                return progressiveBracketsForRawTaxRates(rawTaxRates)
        }
    }

    private static func simpleBracketsForRawTaxRates(_ rawTaxRates: RawTaxRates) -> TaxBracketGroup {
        let brackets = rawTaxRates.sortedRates.map { rawTaxRate in
            TaxBracket(simpleRate: rawTaxRate.rate, startingAt: rawTaxRate.startingAt)
        }
        return TaxBracketGroup(brackets)
    }

    private static func progressiveBracketsForRawTaxRates(_ rawTaxRates: RawTaxRates) -> TaxBracketGroup {
        var previousBracket: TaxBracket?
        var progressiveFixedAmount = 0.0

        let brackets: [TaxBracket] = rawTaxRates.sortedRates.map { rawTaxRate in
            var br: TaxBracket
            if let prev = previousBracket {
                progressiveFixedAmount += prev.rate * (rawTaxRate.startingAt - prev.startingAt)
                br = TaxBracket(fixedAmount: progressiveFixedAmount, plus: rawTaxRate.rate, over: rawTaxRate.startingAt)
            } else {
                br = TaxBracket(simpleRate: rawTaxRate.rate, startingAt: rawTaxRate.startingAt)
            }
            previousBracket = br
            return br
        }

        return TaxBracketGroup(brackets)
    }
}
