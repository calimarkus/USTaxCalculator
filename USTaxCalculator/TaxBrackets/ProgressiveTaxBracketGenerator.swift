//
//

enum SimpleTaxBracketGenerator {
    static func generateWithStartingAtToTaxRateMap(_ startingAtToTaxRateMap: [Double: Double]) -> [TaxBracket] {
        let sortedMap = startingAtToTaxRateMap.sorted { $0.0 < $1.0 }
        return sortedMap.map { startingAt, taxRate in
            TaxBracket(simpleRate: taxRate, startingAt: startingAt)
        }
    }
}

enum ProgressiveTaxBracketGenerator {
    static func generateWithStartingAtToTaxRateMap(_ startingAtToTaxRateMap: [Double: Double]) -> [TaxBracket] {
        let sortedMap = startingAtToTaxRateMap.sorted { $0.0 < $1.0 }
        var previousBracket: TaxBracket?
        var progressiveFixedAmount = 0.0
        return sortedMap.map { startingAt, taxRate in
            var br: TaxBracket
            if let prev = previousBracket {
                progressiveFixedAmount += prev.rate * (startingAt - prev.startingAt)
                br = TaxBracket(fixedAmount: progressiveFixedAmount, plus: taxRate, over: startingAt)
            } else {
                br = TaxBracket(simpleRate: taxRate, startingAt: startingAt)
            }
            previousBracket = br
            return br
        }
    }
}
