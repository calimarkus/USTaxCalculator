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
        guard let rawRates = RawFederalTaxRates.progressiveIncomeRates[year]?[filingType] else {
            throw TaxBracketFactoryError.missingFederalTaxRates
        }

        return TaxBracketGenerator.progressiveBracketsForRawTaxRates(rawRates)
    }

    static func federalLongtermGainsBrackets(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let rawRates = RawFederalTaxRates.longtermGainsRates[year]?[filingType] else {
            throw TaxBracketFactoryError.missingLongtermGainsRates
        }

        return TaxBracketGenerator.simpleBracketsForRawTaxRates(rawRates)
    }

    static func netInvestmentIncomeBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let rawRates = RawFederalTaxRates.netInvestmentIncomeRates[year]?[filingType] else {
            throw TaxBracketFactoryError.missingNetInvestmentIncomeRates
        }

        return TaxBracketGenerator.simpleBracketsForRawTaxRates(rawRates)
    }


    static func additionalMedicareBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        guard let rawRates = RawFederalTaxRates.additionalMedicareIncomeRates[year]?[filingType] else {
            throw TaxBracketFactoryError.missingAdditionalMedicareRates
        }

        return TaxBracketGenerator.progressiveBracketsForRawTaxRates(rawRates)
    }
}

// state tax brackets
extension TaxBracketFactory {
    static func stateTaxBracketFor(_ state: TaxState, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        if state == .NY, taxableIncome > 107650 {
            // new york doesn't use progressive rates for incomes higher than 107,650
            // see comments on RawTaxRates.nonProgressiveNewYorkStateRates
            if let rawRates = RawStateTaxRates.nonProgressiveNewYorkStateRates[year]?[filingType] {
                return TaxBracketGenerator.simpleBracketsForRawTaxRates(rawRates)
            }
        } else {
            // use progressive rates as usual
            if let rawRates = RawStateTaxRates.forState(state)[year]?[filingType] {
                return TaxBracketGenerator.progressiveBracketsForRawTaxRates(rawRates)
            }
        }

        throw TaxBracketFactoryError.missingStateTaxRates
    }
}

// city tax brackets
extension TaxBracketFactory {
    static func cityTaxBracketFor(_ city: TaxCity, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        guard let rawRates = RawCityTaxRates.forCity(city)[year]?[filingType] else {
            throw TaxBracketFactoryError.missingCityTaxRates
        }

        return TaxBracketGenerator.progressiveBracketsForRawTaxRates(rawRates)
    }
}
