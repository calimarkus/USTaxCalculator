//
//

enum TaxBracketFactoryError: Error {
    case missingStateTaxRates
    case missingCityTaxRates
    case missingFederalTaxRates
    case missingLongtermGainsRates
}

enum TaxBracketFactory {}

// federal tax bracket
extension TaxBracketFactory {
    // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
    static func federalTaxBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        if let map = RawFederalTaxRates.progressiveMaps[year]?[filingType] {
            return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
        }
        throw TaxBracketFactoryError.missingFederalTaxRates
    }
}

// state tax brackets
extension TaxBracketFactory {
    static func stateTaxBracketFor(_ state: TaxState, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        if state == .NY, taxableIncome > 107650 {
            // new york doesn't use progressive rates for incomes higher than 107,650
            // see comments on RawTaxRates.nonProgressiveNewYorkStateRates
            if let map = RawStateTaxRates.nonProgressiveNewYorkStateRates[year]?[filingType] {
                return SimpleTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
            }
        } else {
            // use progressive rates as usual
            if let map = RawStateTaxRates.forState(state)[year]?[filingType] {
                return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
            }
        }

        throw TaxBracketFactoryError.missingStateTaxRates
    }

    static func cityTaxBracketFor(_ city: TaxCity, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        if let map = RawCityTaxRates.forCity(city)[year]?[filingType] {
            return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
        }

        throw TaxBracketFactoryError.missingCityTaxRates
    }
}

// additional federal tax brackets
extension TaxBracketFactory {
    static func federalLongtermGainsBrackets(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        if let map = RawFederalTaxRates.longtermGainsMaps[year]?[filingType] {
            return SimpleTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
        }

        throw TaxBracketFactoryError.missingLongtermGainsRates
    }

    // see https://www.irs.gov/individuals/net-investment-income-tax
    static func netInvestmentIncomeBracketsFor(filingType: FilingType) -> TaxBracketGroup {
        switch filingType {
            case .single:
                return TaxBracketGroup(
                    [TaxBracket(simpleRate: 0.038, startingAt: 200000.0)]
                )
            case .marriedJointly:
                return TaxBracketGroup(
                    [TaxBracket(simpleRate: 0.038, startingAt: 250000.0)]
                )
        }
    }

    // see https://www.healthline.com/health/medicare/additional-medicare-tax
    static func additionalMedicareBracketsFor(filingType: FilingType) -> TaxBracketGroup {
        switch filingType {
            case .single:
                return TaxBracketGroup(
                    [TaxBracket(fixedAmount: 0, plus: 0.009, over: 200000.0)]
                )
            case .marriedJointly:
                return TaxBracketGroup(
                    [TaxBracket(fixedAmount: 0, plus: 0.009, over: 250000.0)]
                )
        }
    }
}
