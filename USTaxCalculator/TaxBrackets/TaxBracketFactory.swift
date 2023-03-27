//
//

enum TaxBracketFactoryError: Error {
    case missingStateTaxRates
    case missingCityTaxRates
    case missingFederalTaxRates
    case missingLongtermGainsRates
    case missingNetInvestmentIncomeRates
    case missingAdditionalMedicareRates
}

enum TaxBracketFactory {}

// federal tax bracket
extension TaxBracketFactory {
    static func federalTaxBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let map = RawFederalTaxRates.progressiveMaps[year]?[filingType] else {
            throw TaxBracketFactoryError.missingFederalTaxRates
        }

        return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
    }

    static func federalLongtermGainsBrackets(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let map = RawFederalTaxRates.longtermGainsMaps[year]?[filingType] else {
            throw TaxBracketFactoryError.missingLongtermGainsRates
        }

        return SimpleTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
    }

    static func netInvestmentIncomeBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let map = RawFederalTaxRates.netInvestmentIncomeMaps[year]?[filingType] else {
            throw TaxBracketFactoryError.missingNetInvestmentIncomeRates
        }

        return SimpleTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
    }


    static func additionalMedicareBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let map = RawFederalTaxRates.additionalMedicareIncomeMaps[year]?[filingType] else {
            throw TaxBracketFactoryError.missingAdditionalMedicareRates
        }

        return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
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
}

// city tax brackets
extension TaxBracketFactory {
    static func cityTaxBracketFor(_ city: TaxCity, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        guard let map = RawCityTaxRates.forCity(city)[year]?[filingType] else {
            throw TaxBracketFactoryError.missingCityTaxRates
        }

        return ProgressiveTaxBracketGenerator.generateWithStartingAtToTaxRateMap(map)
    }
}
