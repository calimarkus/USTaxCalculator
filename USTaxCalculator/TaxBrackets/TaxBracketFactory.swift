//
//
enum TaxBracketFactoryError: Error {
    case noMatchingTaxBracketFound
    case missingStateTaxRates
    case missingFederalTaxRates
}

struct TaxBracketFactory {
    static func findMatchingBracket(_ brackets:[TaxBracket], taxableIncome:Double) throws -> TaxBracket {
        let sortedBrackets = brackets.sorted { $0.startingAt > $1.startingAt }
        let matchingBracket = sortedBrackets.first { bracket in
            return taxableIncome > bracket.startingAt
        }

        if let b = matchingBracket {
            return b
        } else {
            throw TaxBracketFactoryError.noMatchingTaxBracketFound
        }
    }
}

// federal tax bracket
extension TaxBracketFactory {
    // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
    static func federalTaxBracketsFor(taxYear year:TaxYear, filingType:FilingType) throws -> [TaxBracket] {
        if let map = RawStartingAtToTaxRateMap.federalProgressiveMaps[year]?[filingType] {
            return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
        }
        throw TaxBracketFactoryError.missingFederalTaxRates
    }
}

// state tax brackets
extension TaxBracketFactory {
    static func stateTaxBracketFor(_ state:StateOrCity, taxYear year:TaxYear, filingType:FilingType, taxableIncome:Double) throws -> [TaxBracket] {
        if state == .NY && taxableIncome > 107650 {
            // new york doesn't use progressive rates for incomes higher than 107650
            // see comments on RawStartingAtToTaxRateMap.nonProgressiveNewYorkStateRates
            if let map = RawStartingAtToTaxRateMap.nonProgressiveRateMapsForState(state: state)[year]?[filingType] {
                return SimpleTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
            }
        } else {
            // use progressive rates as usual
            if let map = RawStartingAtToTaxRateMap.progressiveMapsForState(state: state)[year]?[filingType] {
                return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
            }
        }

        throw TaxBracketFactoryError.missingStateTaxRates
    }
}

// additional federal tax brackets
extension TaxBracketFactory {
    // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
    static func federalLongtermGainsBrackets() -> [TaxBracket] {
        return [TaxBracket(simpleRate: 0.2, startingAt: 501600),
                TaxBracket(simpleRate: 0.15, startingAt: 80800),
                TaxBracket(simpleRate: 0.0, startingAt: 0)]

    }

    static func netInvestmentIncomeTaxTaxLimit(filingType:FilingType) -> Double {
        switch filingType {
            case .single: return 200000.0
            case .marriedJointly: return 250000.0
        }
    }

    // see https://www.irs.gov/individuals/net-investment-income-tax
    static func netInvestmentIncomeBracketsFor(filingType:FilingType) -> [TaxBracket] {
        return [TaxBracket(simpleRate: 0.038, startingAt: netInvestmentIncomeTaxTaxLimit(filingType: filingType)),
                TaxBracket(simpleRate: 0.0, startingAt: 0)]
    }

    static func additionalMedicareTaxThreshhold(filingType:FilingType) -> Double {
        switch filingType {
            case .single: return 200000.0
            case .marriedJointly: return 250000.0
        }
    }

    // see https://www.healthline.com/health/medicare/additional-medicare-tax
    static func additionalMedicareBracketsFor(filingType:FilingType) -> [TaxBracket] {
        return [TaxBracket(fixedAmount:0, plus: 0.009, over: additionalMedicareTaxThreshhold(filingType: filingType)),
                TaxBracket(simpleRate: 0.0, startingAt: 0)]
    }
}
